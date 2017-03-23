require 'ffaker'
require 'factory_girl'

require File.join(Rails.root, 'spec','support', 'faker_helpers.rb')
include Faker::GeographicHelpers


# Jafeth's house
FactoryGirl.create(:logged_user, last_location: 'POINT(-76.9499743 -12.0632436)', preference_radius: 10000)

# Naren's house
FactoryGirl.create(:logged_user, last_location: 'POINT(-77.0126659 -12.0928396)', preference_radius: 12000)

# Naren's work
FactoryGirl.create(:logged_user, last_location: 'POINT(-77.027306 -12.115957)', preference_radius: 10000)

positions = ['POINT (-76.981391 -12.188758)', 'POINT (-76.96672 -12.125636)', 'POINT (-76.883925 -12.042481)',
             'POINT (-77.016278 -12.194032)', 'POINT (-76.955429 -12.004902)', 'POINT (-77.001746 -12.168365)',
             'POINT (-77.106119 -12.140488)', 'POINT (-77.014367 -12.090045)', 'POINT (-77.107596 -12.075475)',
             'POINT (-77.087424 -12.042319)', 'POINT (-77.028333 -12.045107)', 'POINT (-77.038415 -12.049498)',
             'POINT (-76.940964 -12.092984)', 'POINT(-77.086577 -12.059855)', 'POINT(-77.083719 -12.078820)',
             'POINT(-77.038808 -12.057859)', 'POINT(-77.053506 -12.075027)', 'POINT(-77.071879 -12.097584)',
             'POINT(-76.971850 -12.041089)', 'POINT(-76.990473 -12.073905)', 'POINT(-76.975945 -12.083686)',
             'POINT(-76.982080 -12.110221)', 'POINT(-76.970026 -12.100553)', 'POINT(-76.948230 -12.089050)',
             'POINT(-76.948157 -12.073593)', 'POINT(-76.930420 -12.035911)', 'POINT(-76.989512 -12.078172)']

positions.each do |p|
  u = FactoryGirl.create(:logged_user, last_location: p)
  rand(1..3).times do
    images_attributes = FactoryGirl.attributes_for_list(:product_image, rand(1..2))
    u.products.create(FactoryGirl.attributes_for(:product, images_attributes: images_attributes))
  end
end
