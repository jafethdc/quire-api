class Product < ApplicationRecord
  has_many :images, inverse_of: :product, class_name: 'ProductImage', dependent: :destroy
  belongs_to :seller, class_name: 'User'

  accepts_nested_attributes_for :images

  self.per_page = 10

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :seller, presence: true

  validates_associated :images

end
