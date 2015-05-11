class AddCustomOrderDescriptionToShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :custom_order_description, :text
  end
end
