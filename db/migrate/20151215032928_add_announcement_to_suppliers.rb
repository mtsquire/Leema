class AddAnnouncementToSuppliers < ActiveRecord::Migration
  def change
    add_column :spree_suppliers, :announcement, :text
  end
end
