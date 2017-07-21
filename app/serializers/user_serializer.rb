class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :fb_user_id, :name, :last_loc,
             :access_token, :preference_radius, :profile_picture

  def last_loc
    coordinates = object.last_location.as_text.sub('POINT ', '')[1..-2].split
    { lng: coordinates.first, lat: coordinates.second }
  end

  def profile_picture
    object.profile_picture.url
  end
end
