class ProductImageSerializer < ActiveModel::Serializer
  attributes :id, :url, :img_file_name

  def url
    object.img.url
  end
end
