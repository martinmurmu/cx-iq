class ProductReportsController < ApplicationController
  
#  before_filter :authenticate_user! 
  layout 'application_internal'
  

  before_filter :category_subscription_required, :except => [:psa_report_completion, :refresh]#, :paid_subscription_required
  
  def mail
    report = ProductReport.find(params[:id]) 
    if current_user.allowed_to_generate_report?(report.category)
      respond_to do |format|
        format.pdf { ReportsDispatcher.schedule_delivery(report, current_user, 'pdf') }
        format.csv { ReportsDispatcher.schedule_delivery(report, current_user, 'csv') }
      end
    
      render(:update) {|page|
        page.hide('loading_bar')
        page.alert('The file will be generated and sent to you by email shortly.')
      }
    else
      render(:update) {|page|
        page.hide('loading_bar')
        page.redirect_to subscription_plans_path
      }
    end
  end


  def psa_report_completion
    user = User.find params[:user_id]
    product = Product.find params[:product_id]
    UserMailer.deliver_psa_report_completion(user, "http://svc2.cx-iq.com/opinion/tmp/reports/#{user.id}/#{product.id}/REPORT.html")

    render :text => "ok"
  end
  
  def filter
    # @report = ProductReport.find(params[:id])
    # if params[:clear_filter] == "true"
    #   @report.reset_filter
    # else
    #   unless params[:product_ids].blank?
    #     @report.add_filtered_product_ids params[:product_ids]
    #   end
    #   if params[:enable_filter] == "true"
    #     @report.enable_filter
    #   end
    # end
    #redirect_to(product_report_products_path @product_report)
    # @products = @report.products(params[:page], @report.items_per_page)
    # @manufacturers = Manufacturer.names_by_ids(@products.map{|p| p.attributes['manufacturer']})
    # 
    # render :update do |page|
    #   page.replace_html 'product_report', :partial => 'products/results'
    # end  
    refresh
  end
  
  def update_manufacturers

    if params[:category_id].blank?
      manufacturers = []
    elsif params[:category_id].ends_with? 'category'
      category = Category.find(params[:category_id].to_i)
      manufacturers = category.manufacturers
    elsif params[:category_id].ends_with? 'group'
      group = ProductGroup.find(params[:category_id].to_i)
      manufacturers = group.manufacturers
    end
    render :update do |page|
      page.replace_html 'report_manufacturers_select', :partial => 'manufacturers', :object => manufacturers
    end
  end
  
  def refresh
    @report = ProductReport.find(params[:id])
    
    if params[:form_action] == 'next_page'
      params[:page] = params[:page].to_i + 1
    elsif params[:form_action] == 'prev_page'
      params[:page] = params[:page].to_i - 1
    else
      if params[:clear_filter] == "true"
        @report.reset_filter
      elsif params[:enable_filter] == "true"
        @report.enable_filter
      end
      params[:page] = 1
    end

    unless params[:product_ids].blank?
      @report.add_filtered_product_ids params[:product_ids]
    end

    
    if params[:per_page]
      @report.update_attribute('per_page', params[:per_page].to_i)
      @report.per_page = params[:per_page].to_i
    elsif params[:sort_by]
      if params[:sort_by] == 'CSI'
        if @report.sorting_field == 1
          @report.toggle_sorting_order
        else
          @report.update_attribute('sorting_field', 1)
        end
      elsif params[:sort_by] == 'PFS'
        if @report.sorting_field == 2
          @report.toggle_sorting_order
        else
          @report.update_attribute('sorting_field', 2)
        end
      elsif params[:sort_by] == 'PRS'
        if @report.sorting_field == 3
          @report.toggle_sorting_order
        else
          @report.update_attribute('sorting_field', 3)
        end
      elsif params[:sort_by] == 'PSS'
        if @report.sorting_field == 4
          @report.toggle_sorting_order
        else
          @report.update_attribute('sorting_field', 4)
        end
      elsif params[:sort_by] == 'product_name'
        if @report.sorting_field == 5
          @report.toggle_sorting_order
        else
          @report.update_attribute('sorting_field', 5)
        end
      elsif params[:sort_by] == 'manufacturer'
        if @report.sorting_field == 6
          @report.toggle_sorting_order
        else
          @report.update_attribute('sorting_field', 6)
        end
      elsif params[:sort_by] == 'reviews_count'
        if @report.sorting_field == 7
          @report.toggle_sorting_order
        else
          @report.update_attribute('sorting_field', 7)
        end
      end
      
    end
    
    @products = @report.products(params[:page], @report.items_per_page)
    @manufacturers = Manufacturer.names_by_ids(@products.map{|p| p.attributes['manufacturer']})
    @filtered_products = @report.filtered_product_ids
    
    render :update do |page|
      page.replace_html 'product_report', :partial => 'products/results'
    end
  end
  
  # GET /product_reports
  # GET /product_reports.xml
  # def index
  #   @product_reports = ProductReport.all
  # 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @product_reports }
  #   end
  # end 

  # GET /product_reports/1
  # GET /product_reports/1.xml
  # def show
  #   @product_report = ProductReport.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @product_report }
  #   end
  # end 

  # GET /product_reports/new
  # GET /product_reports/new.xml
  def new
    @product_report = ProductReport.new
    unless params[:selected_category].blank?
      @product_report.product_category = ProductGroup.find params[:selected_category]
    end
    setup_new_report
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_report }
    end
  end

  # GET /product_reports/1/edit
  def edit
    @categories=current_user.categories
    @product_groups=current_user.product_groups
    if current_user.guest?
      @product_report = current_user.product_report
    else
      @product_report = current_user.product_reports.find(params[:id])
    end
    render 'new'
  end

  # POST /product_reports
  # POST /product_reports.xml
  def create

    if current_user.guest? and cookies[:product_reports_demo] == "true"
      flash[:notice] = "You have already viewed report once, in order to continue please register"
      redirect_to new_user_registration_path
      return
    end
    cookies[:product_reports_demo] = {:value => "true", :expires => 180.days.from_now }
    
    if params['product_report']['product_category_id'].ends_with? 'category'
      group = Category.find(params['product_report']['product_category_id'].to_i)
    elsif params['product_report']['product_category_id'].ends_with? 'group'
      group = ProductGroup.find(params['product_report']['product_category_id'].to_i)
    end
    @product_report = ProductReport.new(params[:product_report].merge({:user_id => current_user.id}))
    @product_report.category = group
    unless params[:report_manufacturer_ids].blank? || params[:report_manufacturer_ids].include?("all")
      params[:report_manufacturer_ids].each{|id|
        @product_report.manufacturers << Manufacturer.find(id)
      }
    end

    respond_to do |format|
      if @product_report.nps_range
        if @product_report.save
          session[:product_report_id] = @product_report.id if current_user.guest?
          #flash[:notice] = 'ProductReport was successfully created.'
          format.html { redirect_to(nps_report_products_path @product_report) }
          format.xml  { render :xml => @product_report, :status => :created, :location => @product_report }
        else
          setup_new_report
          format.html { render :action => "new" }
          format.xml  { render :xml => @product_report.errors, :status => :unprocessable_entity }
        end
      else
        if @product_report.save
          session[:product_report_id] = @product_report.id if current_user.guest?
          #flash[:notice] = 'ProductReport was successfully created.'
          format.html { redirect_to(product_report_products_path @product_report) }
          format.xml  { render :xml => @product_report, :status => :created, :location => @product_report }
        else
          setup_new_report
          format.html { render :action => "new" }
          format.xml  { render :xml => @product_report.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /product_reports/1
  # PUT /product_reports/1.xml
  def update
    if current_user.guest?
      @product_report = current_user.product_report
    else
      @product_report = current_user.product_reports.find(params[:id])
    end
    ReportManufacturer.delete_all ["report_id = ?", @product_report.id]
    
    unless params[:report_manufacturer_ids].blank? || params[:report_manufacturer_ids].include?("all")
      params[:report_manufacturer_ids].each{|id|
        @product_report.manufacturers << Manufacturer.find(id)
      }
    end

    unless params['product_report'].blank? || params['product_report']['product_category_id'].blank?
      if params['product_report']['product_category_id'].ends_with? 'category'
        group = Category.find(params['product_report']['product_category_id'].to_i)
      elsif params['product_report']['product_category_id'].ends_with? 'group'
        group = ProductGroup.find(params['product_report']['product_category_id'].to_i)
      end
      @product_report.category = group
    end


    respond_to do |format|
      if @product_report.update_attributes(params[:product_report])
        #flash[:notice] = 'ProductReport was successfully updated.'
        format.html { redirect_to(product_report_products_path @product_report) }
        format.xml  { head :ok }
      else
        setup_new_report
        format.html { render :action => "new" }
        format.xml  { render :xml => @product_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_reports/1
  # DELETE /product_reports/1.xml
  # def destroy
  #   @product_report = ProductReport.find(params[:id])
  #   @product_report.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(product_reports_url) }
  #     format.xml  { head :ok }
  #   end
  # end
  
  private
  
  def paid_subscription_required
    if current_user.categories.size > current_user.categories_subscriptions_allowed
      flash[:notice] = "You've reached the maximum number of categories allowed for your subscription. Please upgrade your plan to proceed."
      redirect_to(subscription_plans_path)
    end
  end
  
  def category_subscription_required
    #Private beta fix
    # if current_user.categories.size <= 0
    #   current_user.subscribe Category.find 2010
    # end
    if current_user.categories.size <= 0
      flash[:notice] = 'You are not subscribed to any product category.'
      redirect_to categories_path
    end
  end

  def setup_new_report
    @categories=current_user.categories
    @product_groups=current_user.product_groups
  end
  
end
