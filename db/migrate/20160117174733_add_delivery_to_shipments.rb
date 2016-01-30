class AddDeliveryToShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :delivery_date, :date
    remove_column :spree_orders, :delivery_date, :date
  end
end
