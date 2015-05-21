class AddCustomFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :custom_message, :text
    add_column :spree_orders, :deliver_by_date, :date
  end
end
