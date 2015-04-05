class MyOrdersController < ApplicationController
	layout "my_orders"
  def index
    @orders = Spree::Order.where(["user_id = ?", current_user.id]).where(["state = 'complete'"])
  end
end
