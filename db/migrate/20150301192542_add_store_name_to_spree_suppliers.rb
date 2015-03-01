class AddStoreNameToSpreeSuppliers < ActiveRecord::Migration
  def change
    add_column :spree_suppliers, :store_name, :string
  end
end
