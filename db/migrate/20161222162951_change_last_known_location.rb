class ChangeLastKnownLocation < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :last_known_location, :last_location
  end
end
