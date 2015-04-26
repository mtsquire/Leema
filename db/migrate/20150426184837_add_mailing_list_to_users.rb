class AddMailingListToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mailing_list, :boolean, :default => false
  end
end
