class User < ApplicationRecord
  has_many :products, inverse_of: :seller, class_name: 'Product', foreign_key: 'seller_id', dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ },
                    uniqueness: { case_sensitive: false }
  validates :full_name, presence: true
end
