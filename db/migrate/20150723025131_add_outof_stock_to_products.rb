class AddOutofStockToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :out_of_stock, :integer, :default => 0
  end
end
