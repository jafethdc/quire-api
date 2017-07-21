require File.join(Rails.root, 'lib', 'images', 'images_helpers.rb')

module Api
  module V1
    class SessionsController < ApplicationController
      before_action :authenticate_with_token, only: [:destroy]

      def create
        fb_profile = validate_fb_user(params[:fb_access_token])
        user = User.find_by_email(fb_profile[:email])
        if user
          if user.update(update_params)
            render json: user, status: 200
          else
            render json: { errors: user.errors.full_messages }, status: 422
          end
        else
          user = User.new(create_params(fb_profile))
          if user.save
            render json: user, status: 201
          else
            render json: { errors: user.errors.full_messages }, status: 422
          end
        end
      end

      def destroy
        if logged_user.update(access_token: nil)
          render json: { success: true }
        else
          render json: { success: false }
        end
      end

      private

      def create_params(fb_profile)
        user_params.merge(access_token: generate_api_token, email: fb_profile[:email],
                          name: fb_profile[:name],          fb_user_id: fb_profile[:id],
                          fb_access_token: params[:fb_access_token],
                          profile_picture_base: ImagesHelpers.url_to_base64(fb_profile.dig(:picture, :data, :url)))
      end

      def update_params
        { access_token: generate_api_token, last_location: user_params[:last_location], fb_access_token: params[:fb_access_token]}
      end

      def user_params
        params.require(:user).permit(:last_location)
      end
    end
  end
end

