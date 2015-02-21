class AddUserProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.text :about
      t.text :location
      t.text :profile_name
    end
  end
end
