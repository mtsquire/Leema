class ChangeIngredientsToTextField < ActiveRecord::Migration
  def change
    change_column :spree_products, :ingredients, :text
  end
end
