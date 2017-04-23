FactoryGirl.define do
  factory :product do
    transient do
      images_count 2
    end

    name { FFaker::Product.product_name }
    description { FFaker::Lorem.paragraph }
    price { rand(0..500) }
    association :seller, factory: :user

    after(:build) do |product, evaluator|
      unless evaluator.images_count == 0
        product.images.build(FactoryGirl.attributes_for_list(:product_image, evaluator.images_count))
      end
    end

    to_create do |instance|
      instance.save(validate: instance.images.any?)
    end
  end
end
