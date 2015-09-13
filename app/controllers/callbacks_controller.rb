class CallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # check if a user already exists and doesn't have a uid attribute
    # then stop the user creation process which triggers an error
    if User.find_by_email(request.env["omniauth.auth"].info.email) && User.find_by_email(request.env["omniauth.auth"].info.email).uid.nil?
      set_flash_message :error, :failure
      redirect_to signin_path
    else
      @user = User.from_omniauth(request.env["omniauth.auth"])
      set_flash_message :success, :fb_success
      sign_in_and_redirect @user
    end
  end
end