class AddDeliveryToShippingRate < ActiveRecord::Migration
  def change
    add_column :spree_shipping_rates, :easy_post_delivery_days, :integer
    add_column :spree_shipping_rates, :easy_post_delivery_date, :string
  end
end
