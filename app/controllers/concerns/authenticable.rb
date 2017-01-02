module Authenticable
  def logged_user
    @current_user
  end

  def authenticate_with_token
    if request.headers['Authorization']
      @current_user = User.find_by(access_token: request.headers['Authorization'])
      unless @current_user
        render json: { errors: ['The authorization header provided is invalid'] }, status: 422
      end
    else
      render json: { errors: ['No authorization header was provided'] }, status: 422
    end
  end

  def match_token_with_user(param_name)
    user = User.find(params[param_name])
    unless user == logged_user
      render json: { errors: ["You are not allowed to access the specified user's information"] }, status: 401
    end
  end

  def user_signed_in?
    @current_user.present?
  end

  def validate_fb_user(access_token)
    graph = Koala::Facebook::API.new(access_token)
    profile = graph.get_object('me', fields: 'id,name,email')
    profile.symbolize_keys
  end

  def generate_api_token
    SecureRandom.base58(24)
  end
end
