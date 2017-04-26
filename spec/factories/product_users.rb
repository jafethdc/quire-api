FactoryGirl.define do
  factory :product_user do
    user
    product
    wish false
    skip false
  end
end
