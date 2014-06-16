ActionController::Routing::Routes.draw do |map|
  
  map.connect "/paper_downloads/test", :controller => 'paper_downloads', :action => 'test'
  map.resources :paper_downloads

  map.resources :wom_requests

  map.devise_for :users
  map.resources :users, :member => [:login_as] do |users|
    users.resources :limitations, :shallow => true
  end
  map.resources :limitations

  map.resources :product_groups, :collection=> {
    :create_my_product => :post,
    :create_from_product_report => :post,
    :new_from_product_report => :get,
    :my_products => :get
  }, :member => {
    :aggregates_set => :post,
    :aggregates_get=> :get,
    :api_produce_mia_report => :get,
    :produce_cia_report => :post,
    :produce_cia_report_settings => :get,
    :produce_trending_products_report => :post,
    :produce_trending_products_report_settings => :get,
    :keywords => :get, :keywords_proxy => :get} do |product_groups|
      product_groups.resources :products, :only => :index, 
        :collection => {:index => :post},
        :member => {:add_to_group => :post, :remove_from_group => :post}
    end

  map.resources :product_reports, :member=>{:filter => :post, :refresh => :post, :mail => :post} do |reports|
    reports.resources :products, :shallow => true
  end

  map.resources :nps_reports, :member=>{:filter => :post, :refresh => :post, :mail => :post} do |reports|
    reports.resources :products, :shallow => true
  end

  map.psa_report_completion '/psa-report-complete/user/:user_id/product/:product_id', :action => 'psa_report_completion', :controller => 'product_reports'

  map.resources :reviews, :manufacturers, :products

  map.resources :categories, :member=>{:subscribe => :post, :unsubscribe => :post}, :collection => {:search => :get} do |categories|
    categories.resources :products, :shallow => true, :only => :index
  end

  map.resources(:products,
                :member=>{
                  :report_settings_set => :post,
                  :report_settings_get => :get,
                  :trending_report_keywords => :get,
                  :psa_report_keywords => :get,
                  :produce_psa_report => :post,
                  :api_produce_psa_report => :get,
                  :produce_psa_report_settings => :get,
                  :produce_trending_report => :post,
                  :produce_trending_report_settings => :get})  do |products|
    products.resources :reviews, :shallow => true
  end

  map.resources :user_messages, :only => [:new, :create]
  map.contact_us_old 'ContactUs', :controller=>'user_messages', :action=>'new'
  map.contact_us 'Contact-Us', :controller=>'user_messages', :action=>'new'
  map.wom_request 'Wom-Request', :controller=>'wom_requests', :action=>'new'
  map.with_options :controller => "pages" do |page|
    page.root :action=>'home'
    page.jroot '/Home', :action=>'home'
    page.jroot_two '/home', :action=>'home'
    page.terms_of_service '/TermsOfService', :action=>'terms_of_service'
    page.registration_finished '/registered', :action=>'registration_finished'
    page.products_v2p_accelerator_old '/Products/V2P-Accelerator', :action=>'products_v2p_accelerator'
    page.products_v2p_accelerator 'V2P-Product-Reviews', :action=>'products_v2p_accelerator'
    page.products_wom 'Word-of-Mouth-Analysis', :action=>'wom'
    page.products_tour '/Products/Tour', :action=>'products_tour'

    page.products_methodology_old '/Products/Methodology', :action=>'products_methodology'
    page.products_methodology 'Consumer-Reports-Analysis', :action=>'products_methodology'
    page.products_prm_old '/Products/MarketIntelligenceReporter', :action=>'products_prm'
    page.products_prm 'Market-Research', :action=>'products_prm'

    page.prm_welcome '/prm_welcome', :action => 'prm_welcome'
#    page.services_old '/services', :action => 'services'
    page.services 'Consumer-Reports-Analysis-Services', :action => 'services'

    page.subscription_plans '/plans', :controller=>'pages', :action=>'plans'
  end
  
  
  map.with_options :controller => "services" do |page|
    page.root :action=>'index'
    page.services '/Services', :action=>'index'
    page.jroot_two '/services', :action=>'index'
  end
  
  map.with_options :controller => "methodology" do |page|
    page.root :action=>'index'
    page.methodology '/Methodology', :action=>'index'
    page.jroot_two '/methodology', :action=>'index'
  end
  
  map.v2p_accelerator_demo_old '/Products/V2P-Accelerator/Demo', :controller=>'v2p_accelerator', :action=>'demo'
  map.v2p_accelerator_product_submit 'V2P-Product-Reviews/Product-Submit', :controller=>'v2p_accelerator', :action=>'product_submit'
  map.v2p_accelerator_demo 'V2P-Product-Reviews/Demo', :controller=>'v2p_accelerator', :action=>'demo'
  map.v2p_accelerator_video 'V2P-Product-Reviews/Video', :controller=>'v2p_accelerator', :action=>'video'
  map.resources :v2p_accelerator, :only => [], :collection => {:compare_with_other_products => :post} 

  map.external_auth '/aai/seam/resource/services-v1/auth/details/:token', :controller=>'auth', :action=>'verify_token'

  map.connect '/v2p_accelerator/auto_complete_for_product_name', :controller => 'products', :action => 'auto_complete_for_product_name'

  map.connect '/MyAccount', :controller => 'registrations', :action => 'edit'
  
  map.connect "/get_captcha", :controller => 'newreports', :action => 'captcha'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
