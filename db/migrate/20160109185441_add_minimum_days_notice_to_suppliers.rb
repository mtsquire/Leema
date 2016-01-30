class AddMinimumDaysNoticeToSuppliers < ActiveRecord::Migration
  def change
    add_column :spree_suppliers, :minimum_days_notice, :integer, :default => 0
  end
end
