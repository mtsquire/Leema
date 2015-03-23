class AddPostageLabelToSpreeShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :postage_label, :string
  end
end
