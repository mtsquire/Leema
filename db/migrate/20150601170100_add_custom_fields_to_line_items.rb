class AddCustomFieldsToLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :custom_order_description, :text
    add_column :spree_line_items, :deliver_by_date, :date
  end
end
