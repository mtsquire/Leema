class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #added as part of SO answer with profile page editing
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  

  protected
    #Added so a user can edit their profile page.
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:date_of_birth, :about)
      end
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:date_of_birth, :first_name, :last_name, :email, :city, :cover_photo, :state, :about, :password, :password_confirmation, :current_password, :store_name, :store_logo, :avatar)
      end
    end

    def layout_by_resource
      if devise_controller? && action_name != "edit"
        "signin"
      else
        "interior"
      end
    end

end
