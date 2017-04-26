class CreateProductUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :product_users do |t|
      t.belongs_to :product, index: true
      t.belongs_to :user, index: true
      t.boolean :wish
      t.boolean :skip

      t.timestamps
    end
  end
end
