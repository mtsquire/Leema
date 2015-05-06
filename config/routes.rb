Rails.application.routes.draw do

  get 'orders/index'
  resources "orders", :controller => :my_orders, :as => :orders
  get 'faq/index'
  resources "faq", :controller => :faq, :as => :faq
  get 'guidelines/index'
  resources "guidelines", :controller => :guidelines, :as => :guidelines
  get 'terms_of_use/index'
  resources "terms-of-use", :controller => :terms_of_use, :as => :terms_of_use
  get 'privacy_policy/index'
  resources "privacy-policy", :controller => :privacy_policy, :as => :privacy_policy

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/store'

# Need to adjust this for FB authentication
  devise_for :users, controllers: { registrations: 'users/registrations', passwords: 'users/passwords' }

  devise_scope :user do
    get 'register', to: 'devise/registrations#new', as: :register
    get 'signin', to: 'devise/sessions#new', as: :signin
    get 'logout', to: 'devise/sessions#destroy', as: :logout
    get 'edit', to: 'devise/registrations#edit', as: :edit
    put "update" => 'devise/registrations#update', as: :updateprofile
  end

  get 'welcome/index'

  get '/sell' => 'sell#index'

  get '/:id', to: 'profiles#show', as: :profile

  root 'welcome#index'

  # for setting up the stripe webhook
  post '/hooks/stripe' => 'hooks#stripe'


end
