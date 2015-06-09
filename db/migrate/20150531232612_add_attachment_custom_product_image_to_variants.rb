class AddAttachmentCustomProductImageToVariants < ActiveRecord::Migration
  def self.up
    change_table :spree_variants do |t|
      t.attachment :custom_product_image
    end
  end

  def self.down
    remove_attachment :spree_variants, :custom_product_image
  end
end
