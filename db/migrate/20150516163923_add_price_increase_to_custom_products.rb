class AddPriceIncreaseToCustomProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :price_increase, :decimal
  end
end
