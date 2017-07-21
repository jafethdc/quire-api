class User < ApplicationRecord
  include PostgisHelpers::Arel

  after_initialize :set_defaults, unless: :persisted?

  has_many :products, inverse_of: :seller, foreign_key: 'seller_id', dependent: :destroy
  has_many :chats, inverse_of: :creator, foreign_key: 'creator_id'
  has_many :product_users, inverse_of: :user

  has_attached_file :profile_picture, styles: { medium: '300x300>', thumb: '100x100>' }
  validates :profile_picture, attachment_presence: true
  do_not_validate_attachment_file_type :profile_picture

  attr_accessor :profile_picture_base
  before_validation :parse_profile_picture, if: :should_parse?

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
    product = Product.arel_table
    user = User.arel_table
    product_user = ProductUser.arel_table

    product_constraints = product.create_on(product[:seller_id].eq(user[:id]))
    user_join = product.create_join(user, product_constraints)

    product_user_constraints = product.create_on(product[:id].eq(product_user[:product_id]).and(product_user[:user_id].eq(id)))
    product_user_join = product.create_join(product_user, product_user_constraints, Arel::Nodes::OuterJoin)

    Product.joins(user_join, product_user_join)
           .where(distance_within(last_location, user[:last_location], radius))
           .where(product_user[:skip].eq(nil).or(product_user[:skip].eq(false)))
           .where(user[:id].not_eq(id))
  end

  def wished_products
    product = Product.arel_table
    product_user = ProductUser.arel_table

    product_user_constraints = product.create_on(product[:id].eq(product_user[:product_id]).and(product_user[:user_id].eq(id)))
    product_user_join = product.create_join(product_user, product_user_constraints)

    Product.joins(product_user_join).where(product_user[:wish].eq(true))
  end

  private

  def should_parse?
    profile_picture_base.present? || new_record?
  end

  def set_defaults
    self.preference_radius ||= 15_000
  end

  def parse_profile_picture
    self.profile_picture = Paperclip.io_adapters.for(profile_picture_base)
  end
end
