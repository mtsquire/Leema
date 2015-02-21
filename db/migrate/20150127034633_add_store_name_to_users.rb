class AddStoreNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :store_name, :string
  end
end
