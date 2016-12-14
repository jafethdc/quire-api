class AddAttachmentImgToProductImages < ActiveRecord::Migration
  def self.up
    change_table :product_images do |t|
      t.attachment :img
    end
  end

  def self.down
    remove_attachment :product_images, :img
  end
end
