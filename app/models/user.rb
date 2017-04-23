
class User < ApplicationRecord
  include PostgisHelpers::Arel

  after_initialize :set_defaults, unless: :persisted?

  has_many :products, inverse_of: :seller, foreign_key: 'seller_id', dependent: :destroy
  has_many :chats, inverse_of: :creator, foreign_key: 'creator_id'

  validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ },
                    uniqueness: { case_sensitive: false }
  validates :fb_user_id, presence: true
  validates :name, presence: true
  validates :last_location, presence: true
  validates :preference_radius, presence: true, numericality: { greater_than_or_equal_to: 0.0 }

  def nearby_users(radius = preference_radius)
    User.where(distance_within(last_location, User.arel_table[:last_location], radius))
        .where.not(id: id)
  end

  def nearby_products(radius = preference_radius)
    Product.joins(:seller)
           .where(distance_within(last_location, User.arel_table[:last_location], radius))
           .where(User.arel_table[:id].not_eq(id))
  end

  private

  def set_defaults
    self.preference_radius ||= 15000
  end

end
