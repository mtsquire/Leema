class AddAvailableRatesToShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :available_rates, :json, default: {}, null: false
  end
end
