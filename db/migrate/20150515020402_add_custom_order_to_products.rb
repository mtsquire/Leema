class AddCustomOrderToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :allow_custom_order, :integer, :default => 0
  end
end
