class AddAttachmentCustomProductImageToOrders < ActiveRecord::Migration
  def self.up
    change_table :spree_orders do |t|
      t.attachment :custom_product_image
    end
  end

  def self.down
    remove_attachment :spree_orders, :custom_product_image
  end
end
