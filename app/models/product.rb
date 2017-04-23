class Product < ApplicationRecord
  has_many :images, inverse_of: :product, class_name: 'ProductImage', dependent: :destroy
  belongs_to :seller, class_name: 'User', inverse_of: :products
  has_many :chats, inverse_of: :product

  accepts_nested_attributes_for :images

  self.per_page = 10

  IMAGES_MINIMUM = 1
  IMAGES_MAXIMUM = 5

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :seller, presence: true
  validates :images, length: { minimum: IMAGES_MINIMUM, maximum: IMAGES_MAXIMUM,
                               message: "should be between #{IMAGES_MINIMUM} and #{IMAGES_MAXIMUM}" }

  validates_associated :images
end
