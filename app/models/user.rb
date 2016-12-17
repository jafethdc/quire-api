include PostgisHelpers

class User < ApplicationRecord
  after_initialize :set_defaults, unless: :persisted?

  has_many :products, inverse_of: :seller, class_name: 'Product', foreign_key: 'seller_id', dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ },
                    uniqueness: { case_sensitive: false }
  validates :full_name, presence: true
  validates :last_known_location, presence: true
  validates :preference_radius, presence: true, numericality: { greater_than_or_equal_to: 0.0 }


  def nearby_users
    table = User.arel_table
    User.where(geographical_distance_from_query(last_known_location, table[:last_known_location]).lt(preference_radius))
        .where.not(id: id)
  end

  def nearby_products
    table = User.arel_table
    Product.joins(:seller)
        .where(geographical_distance_from_query(last_known_location, table[:last_known_location]).lt(preference_radius))
        .where(table[:id].not_eq(id))
  end

  private
    def set_defaults
      self.preference_radius ||= 10000
    end
end
