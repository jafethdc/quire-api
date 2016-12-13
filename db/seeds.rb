require 'ffaker'

10.times do
  spherical_factory = RGeo::Geographic.spherical_factory(srid: 4326)
  User.create(email:                FFaker::Internet.email,
              username:             FFaker::Internet.user_name,
              full_name:            FFaker::Name.name,
              last_known_location:  spherical_factory.point(FFaker::Geolocation.lng,FFaker::Geolocation.lat))
end
