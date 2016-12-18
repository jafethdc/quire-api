module Api
  module V1
    class ProductImagesController < ApplicationController
      before_action :authenticate_with_token, only: [:create, :destroy]

      def index
        user = User.find(params[:user_id])
        product = user.products.find(params[:product_id])
        render json: product.product_images, status: 200
      end

      def create
        product = logged_user.products.find(params[:product_id])
        product_image = product.product_images.build(product_image_params)
        if product_image.save
          render json: product_image, status: 201
        else
          render json: product_image.errors.full_messages, status: 422
        end
      end

      def destroy
        product = logged_user.products.find(params[:product_id])
        product_image = product.product_images.find(params[:id])
        product_image.destroy
        head 204
      end

      private
        def product_image_params
          params.require(:product_image).permit(:img_file_name, :img_base)
        end
    end
  end
end

