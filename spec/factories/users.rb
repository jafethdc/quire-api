require File.join(Rails.root, 'spec', 'support', 'faker_helpers.rb')

include Authenticable
include Faker::GeographicHelpers

FactoryGirl.define do
  factory :user do
    email           { FFaker::Internet.email }
    username        { FFaker::Internet.user_name }
    fb_user_id      { rand(999_999).to_s }
    name            { FFaker::Name.name }
    last_location   { rand_point.as_text }
    profile_picture_base { random_base64_image}

    factory :logged_user do
      access_token { generate_api_token }
    end
  end
end
