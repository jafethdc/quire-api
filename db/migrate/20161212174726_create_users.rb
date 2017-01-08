class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email, null: false
      t.string :name, null: false
      t.st_point :last_known_location, geographic: true
      t.string :access_token
      t.timestamps
    end

    # add_index :users, :username, unique: true
  end
end
