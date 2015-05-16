class AddAttachmentCustomProductImageToProducts < ActiveRecord::Migration
  def self.up
    change_table :spree_products do |t|
      t.attachment :custom_product_image
    end
  end

  def self.down
    remove_attachment :spree_products, :custom_product_image
  end
end
