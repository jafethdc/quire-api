class AddFbIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fb_user_id, :string
  end
end
