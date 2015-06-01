class AddCustomFieldsToVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :custom_message, :text
    add_column :spree_variants, :deliver_by_date, :date
  end
end
