class AddStripeChargeIdToShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :stripe_charge_id, :string
  end
end
