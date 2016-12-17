class Product < ApplicationRecord
  has_many :product_images, inverse_of: :product, dependent: :destroy
  belongs_to :seller, class_name: 'User'

  accepts_nested_attributes_for :product_images

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :seller, presence: true

  validates_associated :product_images

end
