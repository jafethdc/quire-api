class AddPreferenceRadiusToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :preference_radius, :integer
  end
end
