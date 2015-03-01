class AddAttachmentStoreLogoToSpreeSuppliers < ActiveRecord::Migration
  def self.up
    change_table :spree_suppliers do |t|
      t.attachment :store_logo
    end
  end

  def self.down
    remove_attachment :spree_suppliers, :store_logo
  end
end
