require 'open-uri'
require 'pathname'
require 'pp'
require 'hpricot'
require 'cgi'
class NewreportsController < ApplicationController

  def cached_web url
    html = open(url).read
    return fix_relative_urls url,html
  end

  def fix_relative_urls url, content
    p = Pathname.new(url)
    base = "#{p.dirname}/"
    html = Hpricot(content)
    html.search("img, iframe").each { |im|
      im['src'] = "#{base}#{im['src']}" if im['src']
    }
    html.search("a").each { |a|
      a['href'] = "#{base}#{a['href']}" if a['href']
    }
    html.to_s
  end

  def captcha
    session[:fjq_captcha] = rand(5).to_s
    render :text => session[:fjq_captcha]
  end

  def cia_report
    if current_user.guest?
			cookies[:ciareport_guest] = "true"
		elsif !current_user.paying_customer?
	    if !cookies[:ciareport_unpaying_cust]
				cookies[:ciareport_unpaying_cust] = "1"
			else
				cookies[:ciareport_unpaying_cust] = (cookies[:ciareport_unpaying_cust].to_i + 1).to_s
			end
    end

    prepare_psa_report


    #calculating importance
    total_opinions = 0
    @attributes_info.each { |rec| total_opinions += rec[:positive_opinions] + rec[:negative_opinions]}
    @attributes_info.each { |rec| rec[:importance] = (rec[:positive_opinions]+rec[:negative_opinions]).to_f/total_opinions}

    #processing filter parameters
    if params[:only]=='positive'
      @attributes_info.reject! { |r| r[:opinion_score]<1 }
    end

    if params[:only]=='negative'
      @attributes_info.reject! { |r| r[:opinion_score]>1 }
    end


    if params[:first]
      @attributes_info = @attributes_info[0,params[:first].to_i]
    end

    if params.has_key? :importance
      importance_above = params[:importance].to_f/100
      @attributes_info.reject! { |rec| rec[:importance]<importance_above}
    end

    @product = Product.find(params[:product_id]) unless params[:product_id].nil?
    render :layout => "application"
  end

  def product_reviews
    render :layout => false
  end

  def psa_report_csv

    prepare_psa_report

    dir = URI.parse(params[:old_report]).path[1..URI.parse(params[:old_report]).path.rindex("/")]

    file_path = File.join(Rails.root, "public", dir, "psa_report.csv")
    FasterCSV.open(file_path, "wb") do |csv|
      csv << ["Attributes",	"Negative Opinions",	"Positive Opinions",
        "Opinion Score", "Importance"]
      @attributes_info.each do |attr|
        csv << [ attr[:attribute], attr[:negative_opinions],
          attr[:positive_opinions], attr[:opinion_score],
          #(attr[:negative_opinions].to_f/@product_info[:opionions_amount]*100).round(2),
          #(attr[:positive_opinions].to_f/@product_info[:opionions_amount]*100).round(2),
          (attr[:negative_opinions].to_f/@product_info[:opionions_amount]*100).round(2)+
            (attr[:positive_opinions].to_f/@product_info[:opionions_amount]*100).round(2)
        ]
      end
    end

    redirect_to File.join("/", dir, "psa_report.csv")
  end

  def reformat
    @content = cached_web( params[:url] )
    p = Pathname.new(params[:url])
    puts "dirname"
    puts p.dirname
    @base = "#{p.dirname}/"
    #    @customer_satisfaction_graph = open_flash_chart_object( 600, 300, url_for( :action => 'customer_satisfaction_data', :url => params[:url]) )
    #    @number_of_reviews_graph = open_flash_chart_object( 600, 300, url_for( :action => 'number_of_reviews_data', :url => params[:url]) )
    @data = reformat_data_values(params[:url])
    html = Hpricot(open("#{@base}_FEATURES.html").read)
    @products = []
    html.search('a').each { |a|
      product = {}
      product[:html] = a.html
      product[:href] = url_for(:action=>:reformat_attribute, :url=> "#{@base}#{a[:href]}", :title=>a.html)
      @products.push(product)
    }

    #render :layout => "empty"
  end

  # based on this example - http://teethgrinder.co.uk/open-flash-chart-2/data-lines-2.php
  def number_of_reviews_data
    chart = OpenFlashChart.new
    title = Title.new("Number of Reviews")

    line_hollow = LineHollow.new
    line_hollow.text = ""
    line_hollow.width = 1
    line_hollow.colour = '#6363AC'
    line_hollow.dot_size = 5
    data = reformat_data_values(params[:url])
    line_hollow.values = data[:reviews]


    y = YAxis.new
    y.set_range(0,data[:reviews].max*1.2,data[:reviews].max/10+1)

    x = XAxis.new
    x.labels = data[:labels]
    chart.x_axis = x


    #x_legend = XLegend.new("MY X Legend")
    #x_legend.set_style('{font-size: 20px; color: #778877}')

    #y_legend = YLegend.new("MY Y Legend")
    #y_legend.set_style('{font-size: 20px; color: #770077}')

    chart.set_title(title)
    #chart.set_x_legend(x_legend)
    #chart.set_y_legend(y_legend)
    chart.y_axis = y

    chart.add_element(line_hollow)

    render :text => chart.to_s
  end


  def customer_satisfaction_data
    chart =OpenFlashChart.new
    title = Title.new("Customer Satisfaction Index")

    line_hollow = LineHollow.new
    line_hollow.text = ""
    line_hollow.width = 1
    line_hollow.colour = '#6363AC'
    line_hollow.dot_size = 5
    data = reformat_data_values(params[:url])
    line_hollow.values = data[:values]


    y = YAxis.new
    y.set_range(0,data[:values].max*1.2,data[:values].max/10)

    x = XAxis.new
    x.labels = data[:labels]
    chart.x_axis = x


    #x_legend = XLegend.new("MY X Legend")
    #x_legend.set_style('{font-size: 20px; color: #778877}')

    #y_legend = YLegend.new("MY Y Legend")
    #y_legend.set_style('{font-size: 20px; color: #770077}')

    chart.set_title(title)
    #chart.set_x_legend(x_legend)
    #chart.set_y_legend(y_legend)
    chart.y_axis = y

    chart.add_element(line_hollow)

    render :text => chart.to_s
  end

  def reformat_data_values(url)
    #params[:url] = CGI.escapeHTML(params[:url])
    puts "reformat data source: #{url}"
    puts "reading content"
    content = cached_web  url
    #puts content
    puts "content length #{content.size}"
    html = Hpricot(content)
    title = Title.new("Customer Satisfaction Index")
    #    bar = Graph.new
    table = html.search("table").first
    if !table
      puts "--ERROR-- table not found"
    end
    values = []
    labels = []
    reviews = []
    links = []
    table.search("tr").each do |tr|
      unless tr.search("td:eq(1)").innerHTML.blank?
        tr.search("td:eq(1)")
        revs = tr.search("td:eq(1)").innerHTML.to_f
        if revs > 0.0
          values.push tr.search("td:eq(2)").innerHTML.to_f
          reviews.push tr.search("td:eq(1)").innerHTML.to_f
          labels.push tr.search("td:eq(0)").search("a").innerHTML.to_s
          links.push tr.search("td:eq(0)").search("a").try(:attr, "href")
        end
      end
    end
    puts "===extracted values==="
    result = {}
    result[:values] = values.reverse
    result[:labels] = labels.reverse
    result[:reviews] = reviews.reverse
    result[:product] = html.search("h3").first.innerHTML.to_s.gsub("Product:","").strip
    result[:links] = links.reverse
    result[:color] = "%06x" % (rand * 0xffffff)
    result
  end

  def reformat_attribute
    params[:url] = params[:url].gsub(" ","%20")
    content = open(params[:url]).read
    content = fix_relative_urls params[:url], content
    html = Hpricot(content)


    labels = []
    hrefs = []
    values = []
    html.search("tr").each do |tr|
      row = tr.search("td:eq(0) a").html
      if !row.blank?
        hrefs.push tr.search("td:eq(0) a").attr("href")
        labels.push row
        values.push tr.search("td:eq(3)").html.to_f
      end
    end
    @data = {}
    @data[:labels] = labels.reverse
    @data[:hrefs] = hrefs.reverse
    @data[:values] = values.reverse
  end

  def reformat_attribute_chart_source
    # DATA
    params[:url] = params[:url].gsub(" ","%20")
    html = Hpricot(open(params[:url]))
    labels = []
    values = []
    html.search("tr").each do |tr|
      row = tr.search("td:eq(0) a").html
      if !row.blank?
        val = tr.search("td:eq(3)").html.to_f
        if val != 1.0
          labels.push row
          values.push tr.search("td:eq(3)").html.to_f
        end
      end
    end

    labels.reverse!
    values.reverse!

    # flash chart
    chart =OpenFlashChart.new
    title = Title.new(params[:title].capitalize)

    line_hollow = LineHollow.new
    line_hollow.text = ""
    line_hollow.width = 1
    line_hollow.colour = '#6363AC'
    line_hollow.dot_size = 5

    line_hollow.values = values


    y = YAxis.new
    y.set_range(0,values.max*1.2,values.max/10)


    x = XAxis.new
    x.labels = labels
    chart.x_axis = x

    chart.set_title(title)
    chart.y_axis = y

    x_legend = XLegend.new("Periods by Quarter")
    x_legend.set_style('{font-size: 12px; color: #778877}')
    chart.set_x_legend(x_legend)

    y_legend = YLegend.new("Opinion Score")
    y_legend.set_style('{font-size: 12px; color: #778877}')
    chart.set_y_legend(y_legend)

    chart.add_element(line_hollow)

    render :text => chart.to_s
  end


  def reformat_googlecharts
    @data = reformat_data_values(params[:url])
    @product = @data[:product]

    p = Pathname.new(params[:url])
    puts "dirname"
    puts p.dirname
    @base = "#{p.dirname}/"

    html = Hpricot(open("#{@base}_FEATURES.html").read)
    @products = []
    html.search('a').each { |a|
      product = {}
      product[:html] = a.html
      product[:href] = url_for(:action=>:reformat_googlecharts_attribute, :url=> "#{@base}#{a[:href]}", :title=>a.html)
      @products.push(product)
      break if @products.count>10
    }

  end


  def reformat_googlecharts_attribute
    params[:url] = params[:url].gsub(" ","%20")
    html = Hpricot(open(params[:url]))
    labels = []
    values = []
    html.search("tr").each do |tr|
      row = tr.search("td:eq(0) a").html
      if !row.blank?
        labels.push row
        values.push tr.search("td:eq(3)").html.to_f
      end
    end

    labels.reverse!
    values.reverse!
    @data = {}
    @data[:values] = values
    @data[:labels] = labels
  end

  private

  def prepare_psa_report
    begin
      html = open(params[:old_report]).read
    rescue Exception => e
      flash[:error] = "Error during trying to read report link #{params[:old_report]}, error: #{e.message}"
      #      render :layout => "application"
      return
    end

    begin
      @product_info, @attributes_info = parse_psa_report_data(html)
      raise "No data has been found" if @product_info.empty? or @attributes_info.empty?
    rescue Exception => e
      flash[:error] = "Error during trying to parse report data from link #{params[:old_report]}, error: #{e.message}"
      render :layout => "application"
      return
    end
  end

  def parse_psa_report_data(html)
    product_info = {}
    attributes_info = []
    opionions_amount = 0
    Hpricot(html).search("table").each_with_index do |tbl, i|
      tbl.search("tr").each do |tr|
        tds = tr.search("td")
        val = tds[1].html
        val = val.to_f if tds[0].html == "CUSTOMER SATISFACTION INDEX"
        val = val.to_i if tds[0].html == "NUMBER OF REVIEWS"
        product_info[tds[0].html] = val
      end if i == 0
      tbl.search("tr").each do |tr|
        tds = tr.search("td")
        if tds.size > 0
          link = tds[0].search("a")[0]
          dir = params[:old_report][0..(params[:old_report].rindex("/"))]
          link_href = dir + link[:href]
          if link.html != "other_attributes"
            attributes_info << {
              :attribute => link.html,
              :link => link_href,
              :negative_opinions => tds[1].html.to_i,
              :positive_opinions => tds[2].html.to_i,
              :opinion_score => (tds[3].html.to_f > 2.0 ? 2.0 : tds[3].html.to_f)
            }
            opionions_amount += tds[1].html.to_i + tds[2].html.to_i
          end
        end
        product_info[:opionions_amount] = opionions_amount
      end if i == 1
    end
    [product_info, attributes_info]
  end

end
