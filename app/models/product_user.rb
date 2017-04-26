class ProductUser < ApplicationRecord
  belongs_to :user, inverse_of: :product_users
  belongs_to :product, inverse_of: :product_users

  validates :user, presence: true
  validates :product, presence: true
  validate :different_owner

  private

  def different_owner
    return if product.blank? || user.blank?
    if product.seller == user
      errors.add(:base, 'There cannot be a relationship between a user and his own product')
    end
  end
end
