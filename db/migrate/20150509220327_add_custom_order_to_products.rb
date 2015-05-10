class AddCustomOrderToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :custom_order, :boolean, :default => false
  end
end
