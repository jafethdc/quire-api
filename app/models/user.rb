include PostgisHelpers

class User < ApplicationRecord
  after_initialize :set_defaults, unless: :persisted?

  has_many :products, inverse_of: :seller, class_name: 'Product', foreign_key: 'seller_id', dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ },
                    uniqueness: { case_sensitive: false }
  validates :full_name, presence: true
  validates :last_location, presence: true
  validates :preference_radius, presence: true, numericality: { greater_than_or_equal_to: 0.0 }

  def nearby_users(radius = preference_radius)
    User.where(distance_within(last_location, User.arel_table[:last_location], radius))
        .where.not(id: id)
  end

  def nearby_products(radius = preference_radius)
    table = User.arel_table
    Product.joins(:seller)
        .where(distance_within(last_location, table[:last_location], radius))
        .where(table[:id].not_eq(id))
  end

  private
    def set_defaults
      self.preference_radius ||= 15000
    end

end
