module Api
  module V1
    class SessionsController < ApplicationController
      before_action :authenticate_with_token, only: [:destroy]

      def create
        fb_profile = validate_fb_user(params[:fb_access_token])
        if fb_profile
          user = User.find_by_email(fb_profile[:email])
          if user
            if user.access_token.nil?
              user.update_attributes(access_token: generate_api_token)
              render json: user, status: 200
            else
              render json: { errors: ['Session already exists'] }, status: 422
            end
          else
            render json: { errors: ['User not found'] }, status: 404
          end
        else
          render json: { errors: ['There was an error with your fb access token'] }, status: 422
        end
      end

      def destroy
        logged_user.update_attributes(access_token: nil)
        head 204
      end

      private
        def user_params
          params.require(:user).permit(:access_token)
        end

    end
  end
end

