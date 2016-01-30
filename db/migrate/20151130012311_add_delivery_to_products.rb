class AddDeliveryToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :allow_delivery, :integer, :default => 0
    add_column :spree_products, :delivery_fee, :decimal
  end
end
