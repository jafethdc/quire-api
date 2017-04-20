FactoryGirl.define do
  factory :chat do
    association :creator, factory: :user
    product
    url { FFaker::Internet.http_url }
  end
end
