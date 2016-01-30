class AddDeliveryFeeToSuppliers < ActiveRecord::Migration
  def change
    add_column :spree_suppliers, :delivery_fee, :decimal
  end
end
