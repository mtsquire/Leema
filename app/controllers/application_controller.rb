class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #added as part of SO answer with profile page editing
  before_action :configure_permitted_parameters, if: :devise_controller?
  # store the last visited page url for sign in/sign up redirects
  before_filter :store_current_location, :unless => :devise_controller?

  layout :layout_by_resource

  def original_url
    base_url + original_fullpath
  end

  def store_current_location
    store_location_for(:user, request.url)
  end

  def index
    #predictive search shizzz
    @product_names = []
    @allProducts = Spree::Product.all
    @allProducts.each do |product|
      @product_names << product.name
    end
    File.open("public/productnames.json","w") do |f|
      f.write(@product_names.to_json)
    end

    @supplier_names = []
    @allSuppliers = Spree::Supplier.all
    @allSuppliers.each do |supplier|
      @supplier_names << supplier.store_name
    end
    File.open("public/suppliernames.json","w") do |f|
      f.write(@supplier_names.to_json)
    end
  end



  protected

    #Added so a user can edit their profile page.
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:date_of_birth, :about)
      end
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:date_of_birth, :first_name, :last_name, :email, :city, :cover_photo, :state, :about, :password, :password_confirmation, :current_password, :store_name, :store_logo, :avatar, :display_name, :mailing_list)
      end
    end

    def layout_by_resource
      if devise_controller? && action_name != "edit"
        "signin"
      elsif action_name == "edit"
        "editprofile"
      else
        "interior"
      end
    end

end
