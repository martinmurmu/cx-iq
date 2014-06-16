class ProductsController < ApplicationController
 # auto_complete_for :product, :name
 # layout 'application_internal', :only => [:index]
  before_filter :authenticate_user!, :except => [:index, :auto_complete_for_product_name, :show, :case_studies, :report_settings_get, :produce_psa_report, :api_produce_psa_report, :produce_psa_report_settings]
  before_filter :verify_products_per_group_limit, :only => [:add_to_group]
  require 'open-uri'

  def auto_complete_for_product_name
    product_name = params["product"].try(:[],"name") || params["product"]

    @items = Product.find_with_ferret("\"#{product_name}\"*", {:limit => 15})
    render :inline => "<%= auto_complete_result @items, 'name' %>"
  end

  def index
    if !params[:product_report_id].blank?
      @report = ProductReport.find(params[:product_report_id])
      render "old-index", :layout => 'application_internal'
      return
    elsif !params[:nps_report_id].blank?
      @report = ProductReport.find(params[:nps_report_id])
      render "/nps_reports/nps-index", :layout => 'application_internal'
      return
    elsif !params[:category_id].blank?
      @category = Category.find params[:category_id]
      @page_title = "#{@category.name} - Product Catalog"

      if params['l'].blank? || params['l']=='all'
        per_page = 20000
        params[:page] = 1
      else
        per_page = 150
      end

      conditions = []

      unless params['l'].blank?
        if params['l'] == 'numeric'
          conditions = ["LEFT(product.name, 1) >= '0' AND LEFT(product.name, 1) <= '9'"]
        elsif params['l'] == 'all'

        else
          conditions = ["LEFT(UPPER(product.name), 1) = ?", params['l'][0,1].upcase]
        end
      end

      @products = @category.products.paginate :page => params[:page], :order => 'name ASC', :per_page => per_page, :conditions => conditions

      @manufacturers = Manufacturer.names_by_ids(@products.map{|p| p.attributes['manufacturer']})

#      @alphabar_paginator = Product.alpha_find :name, params[:ltr]

      render 'category_index', :layout => false
      return
    elsif !params[:product_group_id].blank?
#      @product_group = current_user.product_groups.find params[:product_group_id]
      @product_group = ProductGroup.find params[:product_group_id]
      if params['form_action'] == 'next_page'
        params[:page] = params[:page].to_i + 1
      elsif params['form_action'] == 'prev_page'
        params[:page] = params[:page].to_i - 1
      end

      if !params[:product].blank?
        @products = Product.find_with_ferret("\"#{params["product"]}\"*", :page => params[:page].blank? ? 1 : params[:page], :per_page => 15)
      else
        @products = [].paginate
      end

      if @products.empty?
        puts "!!!!!!!!!!!!!!!!!!!!!!"
        flash[:notice] = "NOTICE"
	      flash[:warning] = "NOTICE"
      end

      respond_to do |format|
        format.html { render 'search', :layout => "application_internal" }
        format.js {
          render :update do |page|
            page.replace_html 'category_list', :partial => 'products/search_results'
          end
        }
      end
      return
    else
      @products = Product.paginate :page => params[:page], :order => 'name ASC', :per_page => 20
      @manufacturers = Manufacturer.names_by_ids(@products.map{|p| p.attributes['manufacturer']})
    end

    respond_to do |format|
      format.html
    end
  end

  def psa_report_settings

  end

  def case_studies

    respond_to do |format|
      format.html
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

#    respond_to do |format|
#      format.html # show.html.erb
 #     format.xml  { render :xml => @product }
#    end
    render  "show", :layout => 'application_internal'

  end

  def add_to_group
    @product_group ||= current_user.product_groups.find(params[:product_group_id])
    product = Product.find params[:id]

    @product_group.products << product

    if !params[:product].blank?
      @products = Product.find_with_ferret("\"#{params["product"]}\"*", :page => params[:page].blank? ? 1 : params[:page], :per_page => 15)
    else
      @products = [].paginate
    end

    render :update do |page|
      page.replace_html 'category_list', :partial => 'products/search_results'
    end
  end

  def remove_from_group
    @product_group = current_user.product_groups.find(params[:product_group_id])
    product = Product.find params[:id]
    @product_group.products.delete product

    if !params[:product].blank?
      @products = Product.find_with_ferret("\"#{params["product"]}\"*", :page => params[:page].blank? ? 1 : params[:page], :per_page => 15)
    else
      @products = [].paginate
    end

    render :update do |page|
      page.replace_html 'category_list', :partial => 'products/search_results'
    end
  end

######## PSA REPORT ###################################


  def produce_psa_report_settings
    if current_user.guest?
      redirect_to(new_user_registration_path)
    else
      @product = Product.find params['id']
      @report_type = "psa"
      @product_name = @product.name
      if params.has_key?(:old)
        render :layout => "application_internal"
        return
      end
      @page_psa_setting = "psa"
      render "product_groups/produce_cia_report_settings", :layout => "application_internal"
    end
  end

  def produce_psa_report
    old_report_url = ReportGenerator.new(
        :user_id => current_user.id,
        :product_id => params['id']).run(params['threshold'],params['mapping'])
    redirect_to :controller => "newreports", :action => "cia_report", :old_report => "http://#{ActionController::Base.session_options[:host]}#{old_report_url}", :product_id => params['id']
  end

  #this is to be used in external app
  def api_produce_psa_report
    report_url = ReportGenerator.new(
        :user_id => nil,
        :product_id => params['id']).run(params['threshold'],params['mapping'])
    render :text=>report_url
  end

  def psa_report_keywords
    @product = Product.find params['id']
    if params[:test_data]
      render :text => '["accurate","albums","amplification","amplifier","babies","balanced","basically","bass","bass reproduction","capacity","capture quality","card","casual","classical","clean","comfort","companion","components","composer","creative","customer support","decision","deep","design","detail","effects","energy","equipment","f","feature set","females","focus","friendly","fun","gaming","general","headphone amp","headphones","high end","hits","intonation","k701 mids","landscaping","launch","lens","macro","macro lens","matches","memory card","memory sticks","music quality","musicians","other_attributes","outcome","packaging","performance","phones","picture quality","pictures produced","pillow","powerful","pressure","price","produces","product","provides","punchy bass","quality glass","quality products","record","recording quality","reliability","results","returns","set","shipping experience","shots","size","sound quality","sounding","speakers","specs","stands","sticks","storage","strings","system","tracking","transfer rates","transfer speeds","treble response","usability","wide angle"]'
      return
    end
    @user = current_user
    generate_keywords
  end


  def report_settings_get
	  raise "unknown report type #{params[:type]}" unless ['psa','trending'].include? params[:type]
	  group = get_one_product_group
    unless current_user.paying_customer?
      result = nil
    else
      result = eval("group.#{params[:type]}_report_settings")
    end
    render :text => result
  end

  def report_settings_set
	  raise "unknown report type #{params[:type]}" unless ['psa','trending'].include? params[:type]
	  group = get_one_product_group
    eval("group.#{params[:type]}_report_settings = params[:data]")
    group.save
    render :text=> "done"
  end



#### TRENDING REPORT #######################
  def produce_trending_report_settings
    @product = Product.find params['id']
    if !params.has_key?(:nocheck) && !@product.reviews.exists?(['recieve_date <= ? AND recieve_date >= ?', TrendingReportGenerator.generate_quarters.first[1], TrendingReportGenerator.generate_quarters.last[1]])
      render 'products/no_sufficient_data', :layout => "application_internal"
      return
    end

    @report_type = "trending"
    @product_name = @product.name

    if params.has_key?(:old)
			render :layout => "application_internal"
			return
    end
		render "product_groups/produce_cia_report_settings", :layout => "application_internal"
  end

  def produce_trending_report
		@@server_name = "staging.cx-iq.com" #request.env["SERVER_NAME"]
    @product = Product.find params['id']
    if !@product.reviews.exists?(['recieve_date <= ? AND recieve_date >= ?', TrendingReportGenerator.generate_quarters.first[1], TrendingReportGenerator.generate_quarters.last[1]])
      render 'products/no_sufficient_data', :layout => "application_internal_as_all"
    else
      Delayed::Job.enqueue(TrendingReportMailingJob.new(@product.id, current_user.id, params['threshold'],params['mapping']))
      render 'products/report_processing_notice', :layout => "application_internal_as_all"
    end
  end


  def trending_report_keywords
    @product = Product.find params['id']
    if params[:test_data]
      render :text => '["accurate","albums","amplification","amplifier","babies","balanced","basically","bass","bass reproduction","capacity","capture quality","card","casual","classical","clean","comfort","companion","components","composer","creative","customer support","decision","deep","design","detail","effects","energy","equipment","f","feature set","females","focus","friendly","fun","gaming","general","headphone amp","headphones","high end","hits","intonation","k701 mids","landscaping","launch","lens","macro","macro lens","matches","memory card","memory sticks","music quality","musicians","other_attributes","outcome","packaging","performance","phones","picture quality","pictures produced","pillow","powerful","pressure","price","produces","product","provides","punchy bass","quality glass","quality products","record","recording quality","reliability","results","returns","set","shipping experience","shots","size","sound quality","sounding","speakers","specs","stands","sticks","storage","strings","system","tracking","transfer rates","transfer speeds","treble response","usability","wide angle"]'
      return
    end
    @user = current_user
    generate_keywords
  end


  private

  def get_one_product_group
   group_attributes = {:name=>params[:id],:one_product_group=>true,:user_id=>current_user.id}
   group = ProductGroup.find(:first, :conditions=>group_attributes)
   if !group
     group = ProductGroup.create group_attributes
   end   
	 group
  end

  def verify_products_per_group_limit
    @product_group ||= current_user.product_groups.find(params[:product_group_id])
    unless current_user.allowed_to_add_another_product_to_group?(@product_group)
      respond_to do |format|
        format.html { redirect_to :subscription_plans }
        format.js  {
          render :update do |page|
            page.redirect_to :subscription_plans
          end
        }
      end
    end
  end

  def generate_keywords
    report = ReportGenerator.new(:user_id => @user.id, :product_id => @product.id)
    threshold = params['threshold'].to_f
    if threshold > 0.1
      threshold = (110 - threshold) / 10000
    end

    report_place = report.run(threshold, '')

    doc = Nokogiri::HTML(open("http://#{ActionController::Base.session_options[:host]}#{report_place}"))
    attribs = []
    whole_count = 0
    doc.xpath('//table[2]/tr').each do |node|
      attr = node.xpath('td[1]/a').text
      unless attr.blank?
        attribs << {
          :attribute => attr,
          :pos_count => node.xpath('td[2]').text.to_i,
          :neg_count => node.xpath('td[3]').text.to_i,
          :importance => 0
        }
        whole_count += (node.xpath('td[2]').text.to_i + node.xpath('td[3]').text.to_i)
      end
    end
    attribs.each do |attr|
      attr[:importance] = ((attr[:pos_count] + attr[:neg_count]).to_f/whole_count*100).round(2)
    end
    report_map_output = File.join(Rails.root, "tmp", report_place.sub("/REPORT.html", ""), "/map_output.txt")
    output_map = ReportGenerator.process_output_map(report_map_output)
    keywords = output_map.blank? ? '' : ReportGenerator.process_output_map(report_map_output)
    list = keywords.blank? ? [] : keywords.try(:split,("\n")).map{|x| x.split(' => ')}.map{|x| x.first}
    #list = []
    #attribs.each do |attr|
    #  list << {:attr => attr[:attribute], :attr_lbl => "#{attr[:attribute]} - #{attr[:importance]}%", :importance => attr[:importance]}
    #end

    render :json => list.sort.to_json
  end

  def products_tour

  end

end
