class AddFbPhotoLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_photo, :string
  end
end
