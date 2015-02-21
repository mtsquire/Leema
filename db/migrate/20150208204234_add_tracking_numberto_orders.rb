class AddTrackingNumbertoOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :tracking_number, :string
  end
end
