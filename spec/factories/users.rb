FactoryGirl.define do
  factory :user do
    email               { FFaker::Internet.email }
    username            { FFaker::Internet.user_name }
    full_name           { FFaker::Name.name }
    last_known_location { RGeo::Geographic.spherical_factory(srid: 4326).point(FFaker::Geolocation.lng,FFaker::Geolocation.lat) }
  end
end
