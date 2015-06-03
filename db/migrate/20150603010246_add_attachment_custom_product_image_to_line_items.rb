class AddAttachmentCustomProductImageToLineItems < ActiveRecord::Migration
  def self.up
    change_table :spree_line_items do |t|
      t.attachment :custom_product_image
    end
  end

  def self.down
    remove_attachment :spree_line_items, :custom_product_image
  end
end
