class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => :plans
  
  def home
    
  end

  def terms_of_service
    render :layout=>false
  end

  def registration_finished
    
  end

  def products_v2p_accelerator
    #redirect_to products_prm_path
    redirect_to products_path
  end

  def products_methodology
    render :layout=>'application_from_basic'
  end

  def products_prm
    render :layout=>'application_from_basic'
  end

  def prm_welcome
    #if redirected from sign in
    #unless  request.referer && (request.referrer.ends_with? "/users/sign_in") 
      #if it is not first sign in
   #   if (current_user && current_user.sign_in_count.to_i>1)
   #     redirect_to "/users/edit"
   #     return
   #   end
   # end
    
    #reset on first time welcome page display
    if !current_user.guest? && current_user.sign_in_count.to_i<=1
      #to avoid duplicate reset on prm_welcome visit
      current_user.sign_in_count = 2
      current_user.save
      current_user.generate_sample_products
    end   
    
    render :layout=>'application_internal_as_all'    
  end

  def services
    
  end

  def wom
    render :layout=>'application_from_basic'
  end

  def reset_sign_in_count
    if current_user
      current_user.sign_in_count=nil
      current_user.save
      render :text=>"'sign in count' for #{current_user.email} was reset, relogin to see effect (welcome page)"      
    else
      render :text=>"should be logged in"
    end
  end
  
  def samples
    current_user.generate_sample_products
    render :text=>"sample product groups created"
  end
    

  def plans
#    if current_user.distinct_categories_with_reports_within_last_month.size > SpreedlySubscription::PLANS.size
#      render 'call_us'
#    else
#      @plan = SpreedlySubscription::PLANS[(current_user.distinct_categories_with_reports_within_last_month.size)]
#      @plan[:price] = Spreedly::SubscriptionPlan.find(@plan[:id]).price.to_i
#    end
  end

end
