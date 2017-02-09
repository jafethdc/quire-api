class ProductImageSerializer < ActiveModel::Serializer
  attributes :id, :url, :img_content_type

  def url
    object.img.url
  end
end
