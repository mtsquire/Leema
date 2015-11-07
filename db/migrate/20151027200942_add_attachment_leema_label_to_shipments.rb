class AddAttachmentLeemaLabelToShipments < ActiveRecord::Migration
  def self.up
    change_table :spree_shipments do |t|
      t.attachment :leema_label
    end
  end

  def self.down
    remove_attachment :spree_shipments, :leema_label
  end
end
