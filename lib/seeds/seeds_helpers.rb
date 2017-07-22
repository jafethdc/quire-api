require 'koala'
require 'httparty'
require 'open-uri'
require 'base64'
require 'ffaker'
require 'factory_girl'
require File.join(Rails.root, 'lib', 'images', 'images_helpers.rb')

module SeedsHelpers
  module FBTestUsers
    FB = Koala::Facebook

    def self.create
      test_users = FB::TestUsers.new(app_id: ENV['FB_APP_ID'], secret: ENV['FB_SECRET'])
      user = test_users.create(true, 'public_profile,email')
      graph_api = FB::API.new(user['access_token'])
      data = graph_api.get_object('me', fields: 'id,name,email,picture.type(normal)')
      data['fb_user_id'] = data.delete 'id'
      data['fb_access_token'] = user['access_token']
      data['profile_picture_base'] = ImagesHelpers.url_to_base64(data['picture']['data']['url'])
      data.delete('picture')
      data.symbolize_keys
    end
  end

  module MLProducts
    BASE_URL = 'https://api.mercadolibre.com/'.freeze

    def self.all
      @products ||= products
    end

    def self.next
      @index ||= 0
      p = all.at(@index)
      @index = @index < all.length - 1 ? @index.next : 0
      p
    end

    def self.products
      site_id = 'MPE'
      category_id = 'MPE1648'
      limit = 100
      url = BASE_URL + "sites/#{site_id}/search?category=#{category_id}&limit=#{limit}"
      response = HTTParty.get(url)
      products = JSON.parse(response.body, symbolize_names: true)[:results]
      products.map { |p| single_product(p[:id]) }
    end

    def self.single_product(id)
      url = BASE_URL + 'items/' + id.to_s
      response = HTTParty.get(url)
      product = JSON.parse(response.body, symbolize_names: true)
      { name: product[:title], price: product[:price], images_attributes: build_images_attrs(product[:pictures]) }
    end

    def self.build_images_attrs(images)
      images.map do |img|
        { img_base: ImagesHelpers.url_to_base64(img[:secure_url]) }
      end
    end
  end

  module SendBird
    BASE_URL = 'https://api.sendbird.com/v3/'.freeze

    def self.create_user(user)
      headers = { 'Content-Type' => 'application/json, charset=utf8', 'Api-Token' => ENV['SENDBIRD_API_TOKEN'] }
      body = { user_id: user.id.to_s, nickname: user.name, profile_url: '' }
      url = BASE_URL + 'users'
      response = HTTParty.post(url, headers: headers, body: body.to_json)
      response.code == 200
    end
  end

  def self.setup_user(position)
    if Rails.env.production?
      user_attrs = FBTestUsers.create
      user_attrs[:last_location] = "POINT (#{position})"
      user = FactoryGirl.create(:logged_user, user_attrs)

      SendBird.create_user(user)

      user.products.create(Array.new(rand(1..3)) { FactoryGirl.attributes_for(:product, MLProducts.next) })
    else
      user = FactoryGirl.create(:logged_user, last_location: "POINT (#{position})")
      user.products.create(Array.new(rand(1..3)) do
        images_attributes = FactoryGirl.attributes_for_list(:product_image, rand(1..2))
        FactoryGirl.attributes_for(:product, images_attributes: images_attributes)
      end)
    end
    user
  end
end