class ProductGroupsController < ApplicationController
  layout 'application_internal'
  before_filter :authenticate_user!, :except => :keywords_proxy

  before_filter :verify_groups_limit, :only => [:new, :create, :new_from_product_report, :create_from_product_report, :create_my_product  ]
  before_filter :verify_paying_customer, :only => [:index, :my_products]
  require 'open-uri'


  def auto_complete_for_product_name
    product_name = params["product"].try(:[],"name") || params["product"]
    @items = Product.find_with_ferret("\"#{product_name}\"*", {:limit => 15})
    render :inline => "<%= auto_complete_result @items, 'name' %>"
  end

  def keywords_proxy
    @group = ProductGroup.find params['id']
    @user = @group.user
    generate_keywords
  end

  def keywords
    #if params[:test_data]
    #  render :text => '["accurate","albums","amplification","amplifier","babies","balanced","basically","bass","bass reproduction","capacity","capture quality","card","casual","classical","clean","comfort","companion","components","composer","creative","customer support","decision","deep","design","detail","effects","energy","equipment","f","feature set","females","focus","friendly","fun","gaming","general","headphone amp","headphones","high end","hits","intonation","k701 mids","landscaping","launch","lens","macro","macro lens","matches","memory card","memory sticks","music quality","musicians","other_attributes","outcome","packaging","performance","phones","picture quality","pictures produced","pillow","powerful","pressure","price","produces","product","provides","punchy bass","quality glass","quality products","record","recording quality","reliability","results","returns","set","shipping experience","shots","size","sound quality","sounding","speakers","specs","stands","sticks","storage","strings","system","tracking","transfer rates","transfer speeds","treble response","usability","wide angle"]'
    #  return
    #end
    @user = current_user
    @group = current_user.product_groups.find params['id']
    generate_keywords
  end

  def create_from_product_report
    report = current_user.product_reports.find params['report_id']
    if current_user.allowed_to_add_another_product_to_group?(ProductGroup.new, report.filtered_products.size)
      @product_group = ProductGroup.create_from_filtered_product_report(report, current_user, params['product_group']['name'])
      if @product_group.valid?
        redirect_to(product_groups_path)
      else
        render :action => "new_from_product_report"
      end
    else
      redirect_to :subscription_plans
    end
  end

  def create_my_product

    product = Product.find(params[:product_id])

    @product_group = current_user.my_one_product_groups.build(:name => product.id)
    @product_group.save
    @product_group.products << product

    if !params[:product].blank?
      @products = Product.find_with_ferret("\"#{params["product"]}\"*", :page => params[:page].blank? ? 1 : params[:page], :per_page => 15)
      @groups = current_user.my_one_product_groups
      render :update do |page|
        page.replace_html 'category_list', :partial => 'my_products_search_results'
      end
      return
    end


 
    render(:update) {|page|
      page.redirect_to my_products_product_groups_path
    }
    
  end

  def create
    @product_group = current_user.product_groups.build(params[:product_group])

    respond_to do |format|
      if @product_group.save
        format.html { redirect_to(product_groups_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def new
    @product_group = ProductGroup.new(:name => 'My List')
  end

  def new_from_product_report
    @product_group = ProductGroup.new(:name => 'My List')
    redirect_to :subscription_plans unless current_user.allowed_to_add_another_product_to_group?(ProductGroup.new, current_user.product_reports.find(params['report_id']).filtered_products.size)
  end

  def edit
    @product_group = current_user.product_groups.find(params[:id])
  end

  def index
    @groups = current_user.product_groups.all :order => 'name'
  end

  def my_products
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
    @groups = current_user.my_one_product_groups

      respond_to do |format|
        format.html { render 'my_products', :layout => "application_internal" }
        format.js {
          render :update do |page|
            page.replace_html 'category_list', :partial => 'my_products_search_results'
          end
        }
      end
  end

  # called on remove button
  def remove_product 
    @product_group = ProductGroup.find(params[:id], :conditions => ["user_id = ?", current_user.id])
    @product_group.destroy
    my_products
  end

  def destroy
    @product_group = ProductGroup.find(params[:id], :conditions => ["user_id = ?", current_user.id])
    @product_group.destroy

    respond_to do |format|
      if params[:back_to] == 'my_products'
        format.html { redirect_to("/product_groups/my_products?product="+(params[:product] rescue "") + "&page="+(params[:page] rescue "")) }
      else
        format.html { redirect_to(product_groups_url) }
      end
    end
  end

  def update
    @product_group = current_user.product_groups.find(params[:id])

    respond_to do |format|
      if @product_group.update_attributes(params[:product_group])
        format.html { redirect_to(product_groups_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

#### NPS REPORT #######################
  def produce_nps_report_settings
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

  def produce_nps_report
    @@server_name = "aai-ror-staging.cx-iq.com" #request.env["SERVER_NAME"]
    @product = Product.find params['id']
    if !@product.reviews.exists?(['recieve_date <= ? AND recieve_date >= ?', TrendingReportGenerator.generate_quarters.first[1], TrendingReportGenerator.generate_quarters.last[1]])
      render 'products/no_sufficient_data', :layout => "application_internal_as_all"
    else
      Delayed::Job.enqueue(TrendingReportMailingJob.new(@product.id, current_user.id, params['threshold'],params['mapping']))
      render 'products/report_processing_notice', :layout => "application_internal_as_all"
    end
  end


  def produce_cia_report_settings
    @report_type = "cia"
    @group = current_user.product_groups.find params['id']
    if @group.products.count > 6
      render 'group_too_large_notice'
    elsif @group.products.count < 2
      render 'group_too_small_notice'
    end
    @product_name = @group
  end

  def api_produce_mia_report
    group = ProductGroup.find params['id']
    if group.products.count > 6
      render :text=>"group should have not more than 6 products"
    else
      threshold = 75
      if threshold > 0.1
        threshold = (110 - threshold) / 10000
      end
      product_group_id = group.id
      user_id = current_user_id
      mapping = nil

      user = User.find user_id
      group = user.product_groups.find product_group_id
      report = CiaReportGenerator.new(:user_id => user_id, :product_ids => group.product_ids)
      report_urls = report.run(threshold, mapping)
      output_map = ReportGenerator.process_output_map(report_urls[:map_output])
      group.update_attribute 'keywords', ReportGenerator.process_output_map(report_urls[:map_output]) unless output_map.blank?
      render :text => "<pre>"+YAML::dump(report_urls)+"</pre>"
      #UserMailer.deliver_cia_report(user, "#{report_urls[:user_id]}/#{report_urls[:time]}/#{report_urls[:product_id]}")
    end
  end

  def produce_cia_report
    logger.info "produce_cia_report"
    group = ProductGroup.find params['id']
    if group.products.count > 6
      render 'group_too_large_notice'
    else
      threshold = params['threshold'].to_f
      if threshold > 0.1
        threshold = (110 - threshold) / 10000
      end
      logger.info "creating delayed job"
      Delayed::Job.enqueue(CiaReportMailingJob.new(group.id, current_user.id, threshold,params['keywords'],request.host))
      render 'products/report_processing_notice', :layout => "application_internal_as_all"
    end
  end

#### TRENDING REPORT #######################
  def produce_trending_products_report_settings
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

  def produce_trending_products_report
#		@@server_name = "aai-ror-staging.cx-iq.com" #request.env["SERVER_NAME"]
    @product_group = params[:id]
#    if !@product.reviews.exists?(['recieve_date <= ? AND recieve_date >= ?', TrendingReportGenerator.generate_quarters.first[1], TrendingReportGenerator.generate_quarters.last[1]])
#      render 'products/no_sufficient_data', :layout => "application_internal_as_all"
#    else
      Delayed::Job.enqueue(TrendingProductReportMailingJob.new(@product_group, current_user.id, params['threshold'],params['mapping']))
      render 'products/report_processing_notice', :layout => "application_internal_as_all"
#    end
  end
  

  def aggregates_get
   group = current_user.product_groups.find params['id']
   render :text=> group.aggregates  
  end

  def aggregates_set
    group = current_user.product_groups.find params['id']
    group.aggregates = params[:data]
    group.save
    render :text=> "done"
  end

  private

  def verify_groups_limit
    unless current_user.allowed_to_create_new_product_group?
      respond_to do |format|
        format.html { redirect_to :subscription_plans }
        format.js {
          render(:update) {|page|
            page.redirect_to :subscription_plans
          }
        }
      end
    end
  end

  def verify_paying_customer
    unless current_user.paying_customer?
      respond_to do |format|
        format.html { redirect_to :subscription_plans }
        format.js {
          render(:update) {|page|
            page.redirect_to :subscription_plans
          }
        }
      end
    end
  end

  def generate_keywords
    report = CiaReportGenerator.new(:user_id => @user.id, :product_ids => @group.product_ids)
    threshold = params['threshold'].to_f
    if threshold > 0.1
      threshold = (110 - threshold) / 10000
    end

    report_urls = report.run(threshold, '')
    output_map = ReportGenerator.process_output_map(report_urls[:map_output])
    keywords = output_map.blank? ? '' : ReportGenerator.process_output_map(report_urls[:map_output])
    #puts "report_urls #{report_urls.to_yaml}"

    list = keywords.blank? ? [] : keywords.try(:split,("\n")).map{|x| x.split(' => ')}.map{|x| x.first}


#    htmls = Dir.entries(report_urls[:report_output_path]).each.inject([]) do |res, f|
#      res << f if File.basename(f).match(/-.+\.html/)
#      res
#    end
#    attribs = []
#    whole_count = 0
#    htmls.each do |html|
#      attrib = html.slice(1..(html.length)).sub(".html", "")
#      pos_count = 0
#      neg_count = 0
#      #doc = Nokogiri::HTML(File.open(File.join(report_urls[:report_output_path], html)))
#      doc = Nokogiri::HTML(open(URI.escape("#{report_urls[:output_dir_prefix]}/#{html}")))
#      doc.xpath('//table[1]/tr').each do |node|
#        attr = node.xpath('td[1]/a').text
#        unless attr.blank?
#          pos_count += node.xpath('td[2]').text.to_i
#          neg_count += node.xpath('td[3]').text.to_i
#          whole_count += (node.xpath('td[2]').text.to_i + node.xpath('td[3]').text.to_i)
#        end
#      end
#      attribs << {
#        :attribute => attrib,
#        :pos_count => pos_count,
#        :neg_count => neg_count,
#        :importance => 0
#     }
#    end
#    attribs.each do |attr|
#      attr[:importance] = ((attr[:pos_count] + attr[:neg_count]).to_f/whole_count*100).round(2)
#    end


    #list = []
    #attribs.each do |attr|
    #  list << {:attr => attr[:attribute], :attr_lbl => "#{attr[:attribute]} - #{attr[:importance]}%", :importance => attr[:importance]}
    #end
    #render :json => list.sort_by{|i| i[:importance]}.reverse.to_json
    render :json => list.sort.to_json
  end

end
