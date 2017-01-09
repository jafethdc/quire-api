module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_with_token, only: [:update]
      before_action only: [:update] { match_token_with_user(:id) }

      def show
        user = User.find(params[:id])
        render json: user, status: 200
      end

      def create
        fb_profile = validate_fb_user(params[:fb_access_token])
        user = User.new(user_params.merge(access_token: generate_api_token).merge(fb_profile.slice(:email, :name)))
        if user.save
          render json: user, status: 201
        else
          render json: { errors: user.errors.full_messages }, status: 422
        end
      end

      def update
        if logged_user.update(user_params)
          render json: logged_user, status: 200
        else
          render json: { errors: logged_user.errors.full_messages }, status: 422
        end
      end

      private
        def user_params
          params.require(:user).permit(:username, :last_location, :preference_radius)
        end
    end
  end
end

