class AddAvailRatesToSpreeShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :avail_rates, :array
  end
end
