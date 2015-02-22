  Rails.application.routes.draw do

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
  devise_for :users, :controllers => { :registrations => "registrations" }

  devise_scope :user do
    get 'register', to: 'devise/registrations#new', as: :register
    get 'signin', to: 'devise/sessions#new', as: :signin
    get 'logout', to: 'devise/sessions#destroy', as: :logout
    get 'edit', to: 'devise/registrations#edit', as: :edit
    put "update" => 'devise/registrations#update', as: :updateprofile
  end
  #necessary to not throw a routing error on the welcome index page
  resources :products


  get 'welcome/index'

  get '/sell' => 'sell#index'

  get '/:id', to: 'profiles#show', as: :profile

  root 'welcome#index'
  
  #for setting up the stripe webhook
  post '/hooks/stripe' => 'hooks#stripe'

  resources :postmates do
      member do
          post 'get_delivery'
      end
    end

  # Logging in with Facebook #
  # match 'auth/:provider/callback', to: 'sessions#create'
  # match 'auth/failure', to: redirect('/')
  # match 'signout', to: 'sessions#destroy', as: 'signout'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
