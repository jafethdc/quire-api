module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)
        fb_validation_result = valid_fb_user?(params[:fb_access_token])
        if fb_validation_result[:valid]
          user.access_token = generate_api_token
        else
          user.errors.add('FB API error: ', [fb_validation_result[:error_message]])
        end

        if user.valid? and fb_validation_result[:valid]
          user.save
          render json: user, status: 201
        else
          render json: { errors: user.errors.full_messages }, status: 422
        end

      end

      private
        def user_params
          params.require(:user).permit(:username, :email, :full_name, :last_known_location)
        end

    end
  end
end

