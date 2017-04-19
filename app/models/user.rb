include PostgisHelpers

class User < ApplicationRecord
  after_initialize :set_defaults, unless: :persisted?

  has_many :products, inverse_of: :seller, foreign_key: 'seller_id', dependent: :destroy

  validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ },
                    uniqueness: { case_sensitive: false }
  validates :fb_user_id, presence: true
  validates :name, presence: true
  validates :last_location, presence: true
  validates :preference_radius, presence: true, numericality: { greater_than_or_equal_to: 0.0 }

  # Get all the nearby users. It uses the st_dwithin function of postgis for that purpose.
  #
  # @param radius : The radius within which to look for products
  # @return an ActiveRecord_Relation containing the nearby products
  def nearby_users(radius = preference_radius)
    User.where(distance_within(last_location, User.arel_table[:last_location], radius))
        .where.not(id: id)
  end

  # Get all the products belonging to nearby users. It uses the st_dwithin function of postgis
  # for that purpose.
  #
  # @param radius : The radius within to look for products
  # @return an ActiveRecord_Relation containing the nearby products
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
