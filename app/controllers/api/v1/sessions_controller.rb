module Api
  module V1
    class SessionsController < ApplicationController
      before_action :authenticate_with_token, only: [:destroy]

      def create
        fb_profile = validate_fb_user(params[:fb_access_token])
        user = User.find_by_email(fb_profile[:email])
        if user
          if user.access_token.nil?
            user.update_attributes(access_token: generate_api_token)
            render json: user, status: 200
          else
            render json: { errors: ['Session already exists'] }, status: 422
          end
        else
          user = User.new(user_params.merge(access_token: generate_api_token).merge(fb_profile.slice(:email, :name)))
          if user.save
            render json: user, status: 201
          else
            render json: { errors: user.errors.full_messages }, status: 422
          end
        end
      end

      def destroy
        logged_user.update_attributes(access_token: nil)
        head 204
      end

      private
        def user_params
          params.require(:user).permit(:username, :last_location, :preference_radius)
        end
    end
  end
end

