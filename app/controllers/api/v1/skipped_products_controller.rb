module Api
  module V1
    class SkippedProductsController < ApplicationController
      before_action :authenticate_with_token, only: [:create]
      before_action :ensure_product_user_existence, only: [:create]

      def create
        if product_user.update skip: true
          render json: { success: true }
        else
          render json: { success: false }
        end
      end

      private


      def ensure_product_user_existence
        pu_params = { user_id: logged_user.id, product_id: params[:id] || skipped_product_params[:product_id] }
        @product_user = ProductUser.find_by pu_params
        @product_user ||= ProductUser.create pu_params
        unless @product_user.persisted?
          render json: { errors: @product_user.errors.full_messages }, status: 422
        end
      end

      def product_user
        @product_user
      end

      def skipped_product_params
        params.require(:skipped_product).permit(:product_id)
      end
    end
  end
end
