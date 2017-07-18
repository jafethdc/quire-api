class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :created_at, :images, :chat_url
  belongs_to :seller

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username, :fb_user_id, :email, :name, :profile_picture
  end

  def images
    images = object.images.sort_by(&:created_at)
    ActiveModelSerializers::SerializableResource.new(images).as_json
  end

  def chat_url
    return if scope.nil?
    chat = Chat.where(product_id: object.id, creator_id: scope.id).first
    chat and chat.url
  end
end
