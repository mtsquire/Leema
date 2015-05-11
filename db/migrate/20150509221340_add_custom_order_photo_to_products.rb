class AddCustomOrderPhotoToProducts < ActiveRecord::Migration
  def change
    def self.up
      change_table :spree_shipments do |t|
        t.attachment :custom_order_photo
      end
    end

    def self.down
      remove_attachment :spree_shipments, :custom_order_photo
    end
  end
end
