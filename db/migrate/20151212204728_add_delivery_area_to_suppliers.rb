class AddDeliveryAreaToSuppliers < ActiveRecord::Migration
  def change
    add_column :spree_suppliers, :delivery_area, :text
  end
end
