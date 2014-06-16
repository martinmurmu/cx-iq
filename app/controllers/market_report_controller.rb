require 'fastercsv'
require 'csv'
require 'open-uri'
module ApplicationHelper
  def cur_params
    ret = params.clone
    ret.delete(:action)
    ret.delete(:controller)
    ret
  end

  def cur_params_remove list
    ret = cur_params
    list.each do |name|
      ret.delete(name)
    end
    ret
  end

  def filter_link name,value,caption
    ret = cur_params
    selected = ""
    if ret[name]==value || (value.nil? && !(ret.has_key? name))
      selected =" class='selected' "
    end
    if value.nil?
      ret.delete(name)
    else
      ret[name] = value
    end
    raw("<a href=?#{ret.to_query} #{selected}>#{caption}</a>")
  end
end

class MarketReportController < ApplicationController
  def index
    view
  end
  
  def csv_export

    if params[:url]
      source = "http://"+params[:url]
    end

    if params[:lid]
      source = "http://#{report_store_host}/reports/"+params[:lid]+"/table.csv"
    end

    s = open(source).read
    send_data s, :filename=>"market_report.csv"
   
  end

  
  def view_prototype

    @attributes = ['usability','reliability','battery']
    @importance = [30,10,5]
    @products = ['product 1', 'product 2', 'product 3']
    @scores = {}
    entry = {}
    entry[:y] = 1
    entry[:link] = "http://google.com"
    @scores['product 1'] = [entry,1,1]
    @scores['product 2'] = [1,1.2,1.83]
    @scores['product 3'] = [1,0,0.2]

    @total_reviews = 1
    @total_opinions = 2
    
    render "view_prototype"
  end

  def view
    @page_title = "- Market Report"
    data = ""

    data_url = ""
    if params[:lid]
      data_url = "http://#{report_store_host}/reports/"+params[:lid]+"/table.csv"
    elsif params[:url]
      data_url = "http://"+params[:url]
    end
    
    begin
      data = open(data_url).read
    rescue
      render :text => "can't read #{data_url}"
      return
    end
    
    params[:importance] = '>1' if !params.has_key? :importance
    params[:attributes] = "common" if !params.has_key? :attributes
    params[:score]="any" if !params.has_key? :score

    if params[:attributes]=='all' && params[:importance]=='any' && params[:score]=='any'
      view_data data
      return
    end

    @lines = []
    data.gsub! '"',''
    csv.parse(data, :headers => true, :header_converters => :symbol, :col_sep=>',') do |line|
      @lines.push line
    end


    @products = []
    @attributes = []
    score = {}
    @importance = {}
    @link = {}
    @total_opinions = 0

    @lines.each do |line|
      next if line[:attribute] == 'other_attributes'
      if !line[:link].empty?
        @total_opinions += line[:count].to_i
      end
      next if params[:score]=='<1' && line[:score].to_f>=1
      if !@products.include? line[:product]
        @products.push line[:product]
      end
      if !@attributes.include? line[:attribute]
        @attributes.push line[:attribute]
      end
      prod_attr = [line[:product],line[:attribute]]
      score_rec = {}
      score_rec[:y] = line[:score].to_f
      score_rec[:link] = line[:link]
      score[prod_attr] = score_rec
      @importance[prod_attr] = line[:importance].to_f
      @link[prod_attr] = line[:link]
    end

    importance_sum = {}
    importance_count = {}

    @importance.each_pair do |key,val|
      attr = key[1]
      if !importance_count.has_key? attr
        importance_count[attr] = 0
        importance_sum[attr] = 0
      end

      importance_count[attr] += 1
      importance_sum[attr] += val
    end

    importance_avg = {}

    importance_sum.each_pair do |attr,val|
      importance_avg[attr] = importance_sum[attr]/importance_count[attr]
    end
    # make sum of importance equal to 100
    importance_avg_sum = 0
    importance_avg.each_pair { |attr,val| importance_avg_sum += val }
    importance_avg.each_pair { |attr,val| importance_avg[attr] = val*100/importance_avg_sum }
    importance_avg.each_pair { |attr,val| importance_avg[attr] = (val<1 ? val.round(1) : val.round(0)) }

    @attributes.sort! { |a,b| (importance_avg[b] rescue 0) <=> (importance_avg[a] rescue 0) }

    if params[:importance] != 'any'
      @attributes.reject! { |item| 
        if params[:importance].include? '<'
          importance_avg[item]>params[:importance].gsub('<','').to_f
        end
        if params[:importance].include? '>'
          importance_avg[item].to_f<params[:importance].gsub('>','').to_f
        end
      }
    end

    if params[:attributes]=='common'

      scores_per_attribute = {}
      @attributes.each do |attr_name|
        count = 0
        @products.each do |prod_name|
          key = [prod_name,attr_name]
          if (score.has_key? key)
            count+= 1
          end
        end
        scores_per_attribute[attr_name] = count
      end

      @attributes.reject! { |attr|
        scores_per_attribute[attr]<@products.count
      }

    end

    @importance = []
    @attributes.each do |attr|
      @importance.push importance_avg[attr]
    end

    @scores = {}
    @products.each do |product_name|
      @scores[product_name] = []
      @attributes.each do |attr_name|
        prod_attr = [product_name,attr_name]        
        @scores[product_name].push score[prod_attr]
      end
    end



    @total_reviews = 0
    if params[:product_group_id]
      ProductGroup.find(params[:product_group_id]).products.each do |p|
        @total_reviews += p.all_reviews_count
      end
    end

    render "view"
  end

  def show
    product_names = JSON.parse params[:products]
    attribute_names = JSON.parse params[:attributes]
    products = Product.where(:name=>product_names).all
    product_ids = products.map(&:id)

    @report_lines = []

    attributes = ProductAttribute\
      .where(:attribute_name=>attribute_names)\
      .where(:product_id=>product_ids)\
      .group(:attribute_name)\
      .order("avg(importance)").all


    attributes.each do |a|
      report_line = {}
      report_line[:attribute] = a.attribute_name
      report_line[:products] = []

      products.each do |p|
        product_line = {}
        product_line[:product] = p.name
        product_line[:value] = p.product_attributes.select("avg(score) as score").where(:attribute_name=>a.attribute_name).first[:score]
        report_line[:products].push product_line
      end
      @report_lines.push report_line

    end

    @colors = ["#0f0","#00f","#f00","#c30","#03c","#aaa"]
    @products = products


    render "show", :layout=>"raw_document"
  end

  def attributes_for
    products = JSON.parse params[:products]

    product_ids = []
    attributes = nil
    products.each do |p|
      product = Product.find_by_name(p)
      if product
        product_ids.push product.id
      end

      if attributes.nil?
        attributes = product.product_attributes.map(&:attribute_name)
      else
        attributes = attributes & product.product_attributes.map(&:attribute_name)
      end

    end

    if attributes.nil?
      attributes = []
    end

    render :text => attributes.to_json
  end
  
  def xlsx_export
    require 'axlsx'


    if params[:url]
      source = "http://"+params[:url]
    end

    if params[:lid]
      source = "http://#{report_store_host}/reports/"+params[:lid]+"/table.csv"
    end

    data = open(source).read

    @lines = []
    csv.parse(data, :headers => true, :header_converters => :symbol) do |line|
      @lines.push line
    end


#### PREPROCESS DATA
    @products = []
    @attributes = []
    score = {}
    @importance = {}
    @link = {}
    @total_reviews = 0
    @total_opinions = 0
    @lines.each do |line|
      next if line[:attribute] == 'other_attributes'
      next if params[:score]=='<1' && line[:score].to_f>=1
      if !@products.include? line[:product]
        @products.push line[:product]
      end
      if !@attributes.include? line[:attribute]
        @attributes.push line[:attribute]
      end
      prod_attr = [line[:product],line[:attribute]]
      score_rec = {}
      score_rec[:y] = line[:score].to_f
      score_rec[:link] = line[:link]
      score[prod_attr] = score_rec
      @importance[prod_attr] = line[:importance].to_f
      @link[prod_attr] = line[:link]
      if !line[:link].empty?
        @total_reviews += 1
        @total_opinions += line[:count].to_i
      end
    end

    importance_sum = {}
    importance_count = {}

    @importance.each_pair do |key,val|
      attr = key[1]
      if !importance_count.has_key? attr
        importance_count[attr] = 0
        importance_sum[attr] = 0
      end

      importance_count[attr] += 1
      importance_sum[attr] += val
    end

    importance_avg = {}

    importance_sum.each_pair do |attr,val|
      importance_avg[attr] = importance_sum[attr]/importance_count[attr]
    end

    @attributes.sort! { |a,b| (importance_avg[b] rescue 0) <=> (importance_avg[a] rescue 0) }
### DONE



    xlsx = Axlsx::Package.new

    wb = xlsx.workbook

    wb.add_worksheet(:name=>"Sheet 1") do |sheet|
      black_cell = wb.styles.add_style :bg_color=>"00", :fg_color=>"FF", :alignment => {:horizontal=>:center}
      black_cell_left = wb.styles.add_style :bg_color=>"00", :fg_color=>"FF", :alignment => {:horizontal=>:left}
      align_left = wb.styles.add_style :alignment => {:horizontal=>:left}, :border => { :style => :thin, :color =>"00" }
      align_right = wb.styles.add_style :alignment => {:horizontal=>:right}, :border => { :style => :thin, :color =>"00" }
      columns = ["Attribute","Importance"]
      @products.each do |p|
        columns.push p
      end
      styles = []
      styles.push black_cell
      styles.push black_cell
      @products.each { styles.push black_cell_left}
      sheet.add_row columns, :style=>styles


      @attributes.each do |attr_name|
        columns = []
        columns.push attr_name
        columns.push importance_avg[attr_name].to_f.round(2).to_s+"%"
        @products.each do |product_name|
          prod_attr = [product_name,attr_name]
          score_val = ""
          if score.has_key? prod_attr
            score_val = score[prod_attr][:y]
          end
          columns.push score_val
        end

        styles = []
        styles.push align_left
        styles.push align_right
        @products.each do
          styles.push align_right
        end
        sheet.add_row columns, :style => styles
      end
      sheet.column_widths 40, 40, 40, 40, 40, 40, 40, 40
    end

    send_data xlsx.to_stream().read, :filename=>"market_report.xlsx"

  end


private
  def report_store_host
    if (request.host.include? "staging") || (request.host.include? "localhost")
      "staging.cx-iq.com"
    else
      "cx-iq.com"
    end

  end

  def view_data data
    @page_title = "Market Report"
     
    @lines = []
    csv.parse(data, :headers => true, :header_converters => :symbol) do |line|
      @lines.push line
    end

    render :view_data, :layout=>"raw_document"
    
  end

  #fix for fastercsv in different ruby versions
  def csv
    if CSV.const_defined? :Reader
      return FasterCSV
    else
      return CSV
    end
  end
end
