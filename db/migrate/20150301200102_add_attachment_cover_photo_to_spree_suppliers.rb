class AddAttachmentCoverPhotoToSpreeSuppliers < ActiveRecord::Migration
  def self.up
    change_table :spree_suppliers do |t|
      t.attachment :cover_photo
    end
  end

  def self.down
    remove_attachment :spree_suppliers, :cover_photo
  end
end
