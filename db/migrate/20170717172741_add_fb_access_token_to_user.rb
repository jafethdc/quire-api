class AddFbAccessTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fb_access_token, :string
  end
end
