class AddDeliveryDateToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :delivery_date, :date
  end
end
