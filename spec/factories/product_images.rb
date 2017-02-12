require File.join(Rails.root, 'spec','support', 'faker_helpers.rb')

include Faker::ImageHelpers

FactoryGirl.define do
  factory :product_image do
    img_base { random_base64_image }
    association :product, factory: :product_skipped

    factory :product_image_skipped do
      to_create { |instance| instance.save(validate: false) }
    end

  end
end

