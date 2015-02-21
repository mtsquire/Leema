class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, :bypass => true
      #Redirect to user profile page after editing
      redirect_to "/" + current_user.id.to_s
    else
      render "edit"
    end
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
    params[:user][:password].present? ||
    params[:user][:password_confirmation].present?
  end

  def sign_up_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
      params.require(:user).permit(:email, :password, :date_of_birth, :about, :city, :state, :avatar, :cover_photo, :password_confirmation, :store_name, :store_logo)
  end

end
