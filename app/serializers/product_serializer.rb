class ProductSerializer < ActiveModel::Serializer
  attributes :id, :description, :price, :created_at
  belongs_to :seller

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username, :email, :full_name
  end
end
