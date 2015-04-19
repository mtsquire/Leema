class WelcomeController < ApplicationController
	layout "home"
  def index
    @products = Spree::Product.all.shuffle.first(9)
    @images = Spree::Image.all
    @users = User.all
    @suppliers = Spree::Supplier.all

    expires_in 20.hours, :public => true
  end

end
