class AddMailingListPreferenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mailing_list, :integer
  end
end
