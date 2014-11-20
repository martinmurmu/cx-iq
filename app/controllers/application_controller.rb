class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :load_guest_from_session
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(
        :email, :password, :password_confirmation, :current_password, :first_name, :last_name, :company)
    end
  end

  def load_guest_from_session
    @current_user = GuestUser.new if current_user.nil?
    if current_user.guest?
      current_user.subscriptions = session[:subscriptions]
      current_user.product_report_id = session[:product_report_id] 
    end
  end

  def after_sign_in_path_for(resource_or_scope)
#    scope = Devise::Mapping.find_scope!(resource_or_scope)
#    home_path = :"#{scope}_root_path"
#    respond_to?(home_path, true) ? send(home_path) : root_path
    prm_welcome_path
  end

  def require_admin
    redirect_to root_path unless current_user.admin?
  end
  
  protected
  
  def verify_nice_captcha
    session[:fjq_captcha] == params[:captcha]
  end
  

end
