class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :created_at, :images
  belongs_to :seller

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username, :fb_user_id, :email, :name
  end

  def images
    ActiveModelSerializers::SerializableResource.new(object.images.order(:created_at)).as_json
  end
end
