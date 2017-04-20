class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.belongs_to :creator, references: :user, index: true
      t.belongs_to :product, index: true
      t.string :url
      t.timestamps
    end
  end
end
