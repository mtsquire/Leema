class AddStoreLogoToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :store_logo
    end
  end

  def self.down
    remove_attachment :users, :store_logo
  end
end
