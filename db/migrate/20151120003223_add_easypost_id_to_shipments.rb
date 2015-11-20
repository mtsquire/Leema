class AddEasypostIdToShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :easypost_id, :string
  end
end
