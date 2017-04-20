class Chat < ApplicationRecord
  belongs_to :creator, class_name: 'User', inverse_of: :chats
  belongs_to :product, inverse_of: :chats

  validates :product, presence: true
  validates :creator, presence: true
  validates :url, presence: true
  validate :different_members

  private

  def different_members
    return if product.blank? || creator.blank?
    if product.seller == creator
      errors.add(:base, "The product's owner cannot be the chat creator")
    end
  end
end
