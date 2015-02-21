class AddLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :city, :text
    add_column :users, :state, :text
  end
end
