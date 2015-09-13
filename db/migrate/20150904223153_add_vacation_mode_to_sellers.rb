class AddVacationModeToSellers < ActiveRecord::Migration
  def change
    add_column :spree_suppliers, :vacation_mode, :integer, :default => 0
    add_column :spree_suppliers, :return_date, :date
  end
end
