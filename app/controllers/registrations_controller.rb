class RegistrationsController < ApplicationController
  # prepend_before_filter :require_no_authentication, :only => [ :new, :create, :after_registration ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  #include Devise::Controllers::InternalHelpers
  
  # GET /resource/sign_up
  def new
    build_resource
    render_with_scope :new
  end
  
  def after_registration
    
  end

  def not_allowed_email_domains
    ['21cn.com', 'sohu.com', '163.com', 'hotmail.com']
  end

  # POST /resource
  def create
    build_resource

    resource_valid = resource.valid?  

    email_domain_ok = true
    email = params[:user][:email]
    domain = email.split("@").last
    if !domain.blank?
      domain.downcase!
      if not_allowed_email_domains.include? domain
        email_domain_ok = false
        resource.errors.add :email, " domain #{domain} is not allowed. Only users with a recognized corporate email address are entitled for registration."
      end
    end
    

    captcha_ok = verify_nice_captcha #to generate 'try again' on recaptcha
    if !captcha_ok
      resource.errors.add_to_base "Wrong captcha"
    end

    
    if resource_valid && captcha_ok && email_domain_ok
      resource.save
      #set_flash_message :notice, :signed_up
      #sign_in_and_redirect(resource_name, resource)
      render_with_scope :after_registration
    else
      render_with_scope :new
    end
  end

  # GET /resource/edit
  def edit
    render :layout=>'application_internal'
    #render_with_scope :edit
  end

  # PUT /resource
  def update
    if self.resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated
      redirect_to after_sign_in_path_for(self.resource)
    else
      render_with_scope :edit
    end
  end

  # DELETE /resource
  def destroy
    self.resource.destroy
    set_flash_message :notice, :destroyed
    sign_out_and_redirect(self.resource)
  end

  protected

    # Authenticates the current scope and dup the resource
    def authenticate_scope!
      send(:"authenticate_#{resource_name}!")
      self.resource = send(:"current_#{resource_name}").dup
    end
    
  
end
