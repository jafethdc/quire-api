class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :created_at, :images, :chat_url
  belongs_to :seller

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username, :fb_user_id, :email, :name
  end

  def images
    ActiveModelSerializers::SerializableResource.new(object.images.order(:created_at)).as_json
  end

  def chat_url
    return if scope.nil?
    chat = Chat.where(product_id: object.id, creator_id: scope.id).first
    chat and chat.url
  end
end
