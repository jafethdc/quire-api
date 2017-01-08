class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :created_at
  belongs_to :seller

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username, :email, :name
  end

  has_many :images
end
