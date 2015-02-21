class AddCountryToBankAccounts < ActiveRecord::Migration
  def change
    add_column :spree_supplier_bank_accounts, :country, :string
  end
end
