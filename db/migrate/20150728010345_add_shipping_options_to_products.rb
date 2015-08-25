class AddShippingOptionsToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :allow_usps_priority, :integer, :default => 1
    add_column :spree_products, :allow_usps_express, :integer, :default => 1
  end
end
