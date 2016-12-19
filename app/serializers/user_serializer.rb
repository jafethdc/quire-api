class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :full_name, :last_location, :access_token, :preference_radius

  def last_location
    coordinates = object.last_known_location.as_text.sub('POINT ','')[1..-2].split
    { lng: coordinates.first, lat: coordinates.second }
  end
end
