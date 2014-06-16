class CategoriesController < ApplicationController     
  layout 'application_internal'
  #before_filter :authenticate_user!, :except => [:auto_complete_for_manufacturer_name, :auto_complete_for_product_name]

  auto_complete_for :manufacturer, :name
  #auto_complete_for :product, :name
  
  def auto_complete_for_product_name
    product_name = params["product"].try(:[],"name") || params["product"]
    @items = Product.find_with_ferret("\"#{product_name}\"*", {:limit => 15})
    render :inline => "<%= auto_complete_result @items, 'name' %>"
  end

  # GET /categories
  # GET /categories.xml
  def index                                                                                      
    @category = Category.root
    @categories_with_children = @category.children_having_children_and_products
    @categories = @category.children_with_products

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def search
    @category = Category.root
    if params['form_action'] == 'next_page'
      params[:page] = params[:page].to_i + 1
    elsif params['form_action'] == 'prev_page'
      params[:page] = params[:page].to_i - 1
    end
    puts params[:product][:name]
    #@categories = AaiGateway.product_lookup(params[:product][:name], params[:type], current_user.id, params[:page] || 1)
    @categories = Product.product_category_search(params[:product][:name], params[:type], current_user, params[:page] || 1)

    @origin = 'search'
    
    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          page.replace_html 'category_list', :partial => 'categories/search_results'
        end
      }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])
    @categories_with_children = @category.children_having_children_and_products
    @categories = @category.children_with_products 
    
    respond_to do |format|
      format.html { render 'index' }
      format.xml  { render :xml => @category }
    end
  end
  
  def subscribe
    # if current_user.categories.size >= current_user.categories_subscriptions_allowed
    #   flash[:notice] = "You've reached the maximum number of categories allowed for your subscription. Please upgrade your plan to proceed."
    #   render :update do |page|
    #    page.redirect_to(subscription_plans_path)
    #   end
    # else
      subscription = Category.find(params[:id])      

      if current_user.guest?
        #if current_user.subscriptions.blank?
          current_user.subscriptions = [subscription.id]
        #else
        #  current_user.subscriptions << subscription.id
        #end
        session[:subscriptions] = current_user.subscriptions
      else
        current_user.subscribe subscription
      end
      
      if params['origin'] == 'search'
        @category = Category.find 10            
        #@categories = AaiGateway.product_lookup(params[:product], params[:type], current_user.id, params[:page].blank? ? 1 : params[:page])
        @categories = Product.product_category_search(params[:product], params[:type], current_user, params[:page] || 1)
      else
        @category = subscription.parent
        @categories_with_children = @category.children_with_children
        @categories = @category.children_with_products
      end
      
      render :update do |page|
        if params['origin'] == 'search'
          page.replace_html 'category_list', :partial => 'categories/search_results'
        else
          page.replace_html 'category_list', :partial => 'categories/categories'
        end
      end 
    # end
  end
  
  def unsubscribe
    if current_user.guest?
      render :update do |page|
        page.redirect_to new_user_registration_path
      end
    else
      subscription = Category.find(params[:id])
      current_user.unsubscribe subscription

    
      if params['origin'] == 'search'
        @origin = 'search'
        @category = Category.find 10
        #@categories = AaiGateway.product_lookup(params[:product], params[:type], current_user.id, params[:page].blank? ? 1 : params[:page])
        @categories = Product.product_category_search(params[:product], params[:type], current_user, params[:page] || 1)
      else
        @category = Category.find(params[:original_category_id])
        @categories_with_children = @category.children_with_children
        @categories = @category.children_with_products
      end

      render :update do |page|
        if params['origin'] == 'search'
          page.replace_html 'category_list', :partial => 'categories/search_results'
        else
          page.replace_html 'category_list', :partial => 'categories/categories'
        end
      end
    end
  end
  
  # 
  # # GET /categories/new
  # # GET /categories/new.xml
  # def new
  #   @category = Category.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @category }
  #   end
  # end
  # 
  # # GET /categories/1/edit
  # def edit
  #   @category = Category.find(params[:id])
  # end
  # 
  # # POST /categories
  # # POST /categories.xml
  # def create
  #   @category = Category.new(params[:category])
  # 
  #   respond_to do |format|
  #     if @category.save
  #       flash[:notice] = 'Category was successfully created.'
  #       format.html { redirect_to(@category) }
  #       format.xml  { render :xml => @category, :status => :created, :location => @category }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PUT /categories/1
  # # PUT /categories/1.xml
  # def update
  #   @category = Category.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @category.update_attributes(params[:category])
  #       flash[:notice] = 'Category was successfully updated.'
  #       format.html { redirect_to(@category) }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /categories/1
  # # DELETE /categories/1.xml
  # def destroy
  #   @category = Category.find(params[:id])
  #   @category.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(categories_url) }
  #     format.xml  { head :ok }
  #   end
  # end
end
