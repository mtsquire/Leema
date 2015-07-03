class AddPickupOptionToSuppliers < ActiveRecord::Migration
  def change
    add_column :spree_suppliers, :allow_pickup, :integer, :default => 0
  end
end
