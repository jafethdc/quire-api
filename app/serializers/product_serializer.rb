class ProductSerializer < ActiveModel::Serializer
  attributes :id, :description, :price, :created_at
  belongs_to :seller
end
