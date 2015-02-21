class ProfilesController < ApplicationController
  layout "profiles"
  def show  
    @user = User.find(params[:id])
    @supplier = @user.supplier

    if @user
      render action: :show
    else
      render file: 'public/404', status: 404, format: [:html]
    end

  end

end
