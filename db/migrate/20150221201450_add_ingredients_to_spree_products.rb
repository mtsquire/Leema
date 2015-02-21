class AddIngredientsToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :ingredients, :string
  end
end
