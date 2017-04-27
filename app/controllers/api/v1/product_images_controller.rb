module Api
  module V1
    class ProductImagesController < ApplicationController
      before_action :authenticate_with_token, only: [:create, :destroy]
      before_action only: [:create, :destroy] { match_token_with_user(:user_id) }

      def index
        user = User.find(params[:user_id])
        product = user.products.find(params[:product_id])
        render json: product.images.order(:created_at), status: 200
      end

      def create
        product = logged_user.products.find(params[:product_id])
        if product.update(images_attributes: [product_image_params])
          render json: product.images.last, status: 201
        else
          render json: { errors: product.errors.full_messages }, status: 422
        end
      end

      def destroy
        product = logged_user.products.find(params[:product_id])
        product_image = product.images.find(params[:id])
        product_image.destroy
        if product_image.destroyed?
          render json: { success: true }
        else
          render json: { success: false }
        end
      end

      private

      def product_image_params
        params.require(:product_image).permit(:img_base)
      end
    end
  end
end

