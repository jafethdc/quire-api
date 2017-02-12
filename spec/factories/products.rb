FactoryGirl.define do
  factory :product_basic, class: Product do
    name { FFaker::Product.product_name }
    description { FFaker::Lorem.paragraph }
    price { rand(0..500) }
    association :seller, factory: :user

    factory :product do
      after(:build) do |product, _|
        product.images.build(FactoryGirl.attributes_for_list(:product_image_skipped, rand(1..3)))
      end
    end

    factory :product_skipped do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
