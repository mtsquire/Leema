class AddTransferredStateToShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :transferred, :boolean, :default => false
  end
end
