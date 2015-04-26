class ChangeMailingListToInt < ActiveRecord::Migration
  def change
    change_column :users, :mailing_list, :integer
  end
end
