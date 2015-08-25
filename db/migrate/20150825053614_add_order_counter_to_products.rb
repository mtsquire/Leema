class AddOrderCounterToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :sales_count, :integer, :default => 0
  end
end
