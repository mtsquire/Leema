class AddDescriptionToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :leema_description, :text
  end
end
