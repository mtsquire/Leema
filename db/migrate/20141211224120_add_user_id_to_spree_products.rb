class AddUserIdToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :user_id, :integer
    add_index :spree_products, :user_id
  end
end
