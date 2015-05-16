class AddCustomFieldsToCustomProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :custom_message, :text
    add_column :spree_products, :deliver_by_date, :date
  end
end
