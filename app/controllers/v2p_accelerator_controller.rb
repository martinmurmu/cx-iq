require 'open-uri'
class V2pAcceleratorController < ApplicationController

  layout "application"
  def demo
    if params['product']
      @product = Product.find_by_name params['product']['name']
    else
      @product = nil
    end
    if @product
      @page_title = "#{@product.name}"
    else
      @page_title = "Customer Reviews & Product Reputation"
    end
  end

  def tooltip_test

  end

  def compare_with_other_products
    product = Product.find params['product_id']
    group = product.categories.first
    @product_report = ProductReport.new({:user_id => current_user.id, :sorting_field => 1, :number_of_reviews => 4, :sorting_order => 2})
    @product_report.category = group
    respond_to do |format|
      if @product_report.save
        session[:product_report_id] = @product_report.id if current_user.guest?
        format.html { redirect_to(product_report_products_path @product_report) }
      end
    end
  end

  def product_submit
    @errors = []
    @error_fields = {}
    if params[:commit]
      mandatory = [:username,:email,:manufacturer, :product, :review_url_1]
      mandatory.each do |f|
      	if params[f].blank?
          if f==:username
            field_name = "name"
          end
          if f==:email
            field_name = "company email"
          end
          if f==:manufacturer
            field_name = "company name"
          end
          if f==:review_url_1
            field_name = "review url"
          end
      	  @errors.push field_name.capitalize+" can't be blank"
      	  @error_fields[f] = true;
        end
      end

      if !params[:email].blank?
          unless params[:email] =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
            @errors.push "Your email address does not appear to be valid"
            @error_fields[:email] = true
          end
      end

      urls = [:review_url_1]
      urls.each do |f|
      	if !params[f].blank?
      	  exists = (open(params[f]) rescue false)
      	  if exists===false
      	    @errors.push "Review url #{params[f]} is wrong"
      	    @error_fields[f] = true
      	  end
        end
      end

      if !verify_recaptcha
         @errors.push "Error: wrong or no captcha"
      end

      if @errors.count == 0
         recipient = 'greg@amplifiedanalytics.com'
         recipient = 'nazar.kuliev@gmail.com' if root_url.include? "localhost"
         #recipient = 'dmitry.verk@gmail.com'

  	     subject = "New Product Submitted"
         Emailer.deliver_product_submit(recipient, subject, params)
         um = UserMessages.new({:name => params[:username], :email => params[:email],:company=>'product submit form',:message=>params.map{|k,v| "#{k}: #{v}"}.join("\n")})
         um.save!
         render "product_submitted"
      end


    end


  end

  def video
    render :layout => "empty"
  end

end
