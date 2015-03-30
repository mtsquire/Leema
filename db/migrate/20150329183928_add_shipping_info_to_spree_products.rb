class AddShippingInfoToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :shipping_information, :text
  end
end
