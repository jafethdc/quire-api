FactoryGirl.define do
  factory :user do
    email               { FFaker::Internet.email }
    username            { FFaker::Internet.user_name }
    full_name           { FFaker::Name.name }
    last_known_location { RGeo::Geographic.spherical_factory(srid: 4326)
                                          .point(FFaker::Geolocation.lng, FFaker::Geolocation.lat) }
    preference_radius   { rand(1000..400000) }

    factory :logged_user do
      access_token        { SecureRandom.base58(24) }
    end
  end
end
