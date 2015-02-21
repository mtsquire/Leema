class RemoveUserProfiles < ActiveRecord::Migration
  def up
    drop_table :profiles
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
