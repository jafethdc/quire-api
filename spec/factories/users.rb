require File.join(Rails.root, 'spec','support', 'faker_helpers.rb')

include Authenticable
include Faker::GeographicHelpers

FactoryGirl.define do
  factory :user do
    email               { FFaker::Internet.email }
    username            { FFaker::Internet.user_name }
    full_name           { FFaker::Name.name }
    last_location       { rand_point.as_text }

    factory :logged_user do
      access_token        { generate_api_token }
    end
  end
end
