class AddAbbreviatedLocationToSeller < ActiveRecord::Migration
  def change
    add_column :spree_suppliers, :abbreviated_location, :string
  end
end
