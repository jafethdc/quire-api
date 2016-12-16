module Authenticable
  def logged_user
    unless @current_user
      unless request.headers['Authorization']
        raise ActiveRecord::RecordNotFound.new('No user was found', User.to_s, User.primary_key)
      end
      @current_user = User.find_by(access_token: request.headers['Authorization'])
      unless @current_user
        raise ActiveRecord::RecordNotFound.new('No user was found', User.to_s, User.primary_key)
      end
    end
    @current_user
  end

  def authenticate_with_token
    render json: { errors: ['Not authenticated'] }, status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    logged_user.present?
  end

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
