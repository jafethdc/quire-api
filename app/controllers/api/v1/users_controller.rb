module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_with_token, only: [:update]
      before_action only: [:update] { match_token_with_user(:id) }

      def update
        if logged_user.update(user_params)
          render json: logged_user, status: 200
        else
          render json: { errors: logged_user.errors.full_messages }, status: 422
        end
      end

      private

      def user_params
        params.require(:user).permit(:username, :last_location, :preference_radius, :fb_user_id)
      end
    end
  end
end
