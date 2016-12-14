module Api
  module V1
    class SessionsController < ApplicationController
      def create
        fb_validation_result = valid_fb_user?(params[:access_token])
        if fb_validation_result[:valid]
          user = User.find_by_email(fb_validation_result[:profile]['email'])
          if user
            if user.access_token.nil?
              user.update_attribute(:access_token, generate_api_token)
              render json: user, status: 200
            else
              user.errors.add(:session, 'already exists')
              render json: { errors: user.errors.full_messages }, status: 422
            end
          else
            render json: { errors: ['user not found'] }, status: 404
          end
        else
          render json: { errors: [fb_validation_result[:error_message]] }, status: 422
          end
      end

      def destroy
        user = User.find_by_access_token(user_params[:access_token])
        if user
          user.update_attribute(:access_token, nil)
          head 204
        else
          render json: { errors: ['user not found'] }, status: 404
        end
      end

      private
        def user_params
          params.require(:user).permit(:access_token)
        end

      include Error::ErrorHandler
    end
  end
end

