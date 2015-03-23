class AddDeliveryToSpreeShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :delivery_days, :string
    add_column :spree_shipments, :delivery_date, :date
  end
end
