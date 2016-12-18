FactoryGirl.define do
  factory :product do
    name { FFaker::Product.product_name }
    description { FFaker::Lorem.paragraph }
    price { rand(0..500) }
    association :seller, factory: :user
  end
end
