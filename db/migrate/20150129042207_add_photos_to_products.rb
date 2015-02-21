class AddPhotosToProducts < ActiveRecord::Migration
  def self.up
    change_table :spree_products do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :spree_products, :photo
  end
end
