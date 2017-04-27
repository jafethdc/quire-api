class ChatSerializer < ActiveModel::Serializer
  attributes :id, :product_id, :creator_id, :url
end
