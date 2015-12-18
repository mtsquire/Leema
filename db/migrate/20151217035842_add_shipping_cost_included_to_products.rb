class AddShippingCostIncludedToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :shipping_included, :integer, :default => 0
  end
end
