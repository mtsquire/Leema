class AddCustomFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :custom_message, :text
    add_column :spree_orders, :deliver_by_date, :date
    remove_column :spree_products, :custom_message, :text
    remove_column :spree_products, :deliver_by_date, :date
  end
end
