require 'koala'

class ApplicationController < ActionController::API

  def valid_fb_user?(access_token)
    begin
      graph = Koala::Facebook::API.new(access_token)
      profile = graph.get_object('me', fields: 'id,name,email')
      { valid: profile.include?('id'), profile: profile }
    rescue Koala::Facebook::APIError => e
      { valid: false, error_message: e.message}
    end
  end

  def generate_api_token
    SecureRandom.base58(24)
  end
end
