Rails.application.routes.draw do

  get "/paper_downloads/test", :controller => 'paper_downloads', :action => 'test'
  resources :paper_downloads

  resources :wom_requests

  devise_for :users

  resources :users, :member => [:login_as] do |users|
    resources :limitations, :shallow => true
  end

  resources :limitations

  resources :product_groups do
    collection do
      post :create_my_product
      post :create_from_product_report
      get  :new_from_product_report
      get  :my_products
    end 
    member do
      post :aggregates_set
      get  :aggregates_get
      get  :api_produce_mia_report
      post :produce_cia_report
      get  :produce_cia_report_settings
      post :produce_trending_products_report
      get  :produce_trending_products_report_settings
      get  :keywords 
      get  :keywords_proxy
    end
    resources :products, :only => :index do
      collection do
        post :index
      end
      member do
        post :add_to_group 
        post :remove_from_group
      end
    end
  end
 
  resources :product_reports do
    member do
      post :filter
      post :refresh
      post :mail
    end
    resources :products, :shallow => true
  end

  resources :nps_reports do
    member do
      post :filter
      post :refresh 
      post :mail
    end
    resources :products, :shallow => true
  end

  get '/psa-report-complete/user/:user_id/product/:product_id', :action => 'psa_report_completion', :controller => 'product_reports'

  resources :reviews
  resources :manufacturers
  resources :products

  resources :categories do
    member do
      post :subscribe
      post :unsubscribe
    end
   
    collection do
      get :search
    end
    resources :products, :shallow => true, :only => :index
  end

  resources :products do
    member do
      post :report_settings_set
      get :report_settings_get
      get :trending_report_keywords
      get :psa_report_keywords
      post :produce_psa_report
      get  :api_produce_psa_report
      get  :produce_psa_report_settings
      post :produce_trending_report
      get :produce_trending_report_settings
    end
    resources :reviews, :shallow => true
  end

  resources :user_messages, :only => [:new, :create, :index]
  
  get 'product_groups/autocomplete_product_name'
  get 'ContactUs', :controller=>'user_messages', :action=>'new', as: 'contact_us_old'
  get 'Contact-Us', :controller=>'user_messages', :action=>'new', as: 'contact_us'
  #map.wom_request 'Wom-Request', :controller=>'wom_requests', :action=>'new'
  #map.with_options :controller => "pages" do |page|
    root 'pages#home'
    get '/Home' => 'pages#home', as: :jroot
    get '/home' => 'pages#home', as: :jroot_two
    get '/TermsOfService' => 'pages#terms_of_service', as: 'terms_of_service'
    get '/registered' =>'pages#registration_finished', as: 'registration_finished'

    get '/Products/V2P-Accelerator' =>'pages#products_v2p_accelerator', as: 'products_v2p_accelerator_old'    
    get 'V2P-Product-Reviews' => 'pages#products_v2p_accelerator', as: 'products_v2p_accelerator'    
    get 'Word-of-Mouth-Analysis' =>'pages#wom', as: 'products_wom'
    get '/Products/Tour' => 'pages#products_tour', as: 'products_tour'

    get '/Products/Methodology' =>'pages#products_methodology', as: 'products_methodology_old'
    get 'Consumer-Reports-Analysis' =>'pages#products_methodology', as: 'products_methodology'
    get '/Products/MarketIntelligenceReporter' =>'pages#products_prm', as: 'products_prm_old'
    get 'Market-Research' =>'pages#products_prm', as: 'products_prm'

    get '/prm_welcome' => 'pages#prm_welcome', as: 'prm_welcome'
#    page.services_old '/services', :action => 'services'
    get 'Consumer-Reports-Analysis-Services' => 'services', as: 'consumer_services'

    get '/plans' => 'pages#plans', as: 'subscription_plans'
  #end
  
  
  #map.with_options :controller => "services" do |page|
  #root "services#index"
  #get '/Services' =>'services#index', as: 'services'
  get '/services'=> 'services#index', as: 'services'
  #end
  #
  #  page.root :action=>'index'
  get '/Methodology' => 'methodology#index', as: 'methodology'
  #get '/methodology' => 'methodoloy#index', as: 'jroot_two'
  #end
  #
  #map.v2p_accelerator_demo_old 
  get '/Products/V2P-Accelerator/Demo' => 'v2p_accelerator#demo', as: :v2p_accelerator_demo_old
  #map.v2p_accelerator_product_submit 
  get 'V2P-Product-Reviews/Product-Submit' => 'v2p_accelerator#product_submit', as: :v2p_accelerator_product_submit
  #map.v2p_accelerator_demo 
  get 'V2P-Product-Reviews/Demo' => 'v2p_accelerator#demo', as: :v2p_accelerator_demo
  #map.v2p_accelerator_video 'V2P-Product-Reviews/Video', :controller=>'v2p_accelerator', :action=>'video'
  #
  resources :v2p_accelerator do 
    collection do
      post :compare_with_other_products
    end
  end

  match '/aai/seam/resource/services-v1/auth/details/:token', :controller=>'auth', :action=>'verify_token', via: [:get, :post]

  match '/v2p_accelerator/auto_complete_for_product_name', :controller => 'products', :action => 'auto_complete_for_product_name', via: [:get, :post]

  match '/MyAccount', :controller => 'registrations', :action => 'edit', via: [:get, :post]
 
  match "/get_captcha", :controller => 'newreports', :action => 'captcha', via: [:get, :post]

  match ':controller/:action/:id', via: [:get, :post]
  match ':controller/:action/:id.:format', via: [:get, :post] 
end
