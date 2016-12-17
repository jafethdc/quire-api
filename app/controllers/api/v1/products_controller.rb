module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_with_token, only: [:create, :update, :destroy, :nearby]

      def index
        user = User.find(params[:user_id])
        render json: user.products, status: 200
      end

      def show
        user = User.find(params[:user_id])
        product = user.products.find(params[:id])
        render json: product, status: 200
      end

      def nearby
        render json: logged_user.nearby_products, status: 200
      end

      def create
        product = logged_user.products.build(product_params)
        if product.save
          render json: product, status: 201
        else
          render json: { errors: product.errors.full_messages }, status: 422
        end
      end

      def update
        product = logged_user.products.find(params[:id])
        if product.update(product_params)
          render json: product, status: 200
        else
          render json: { errors: product.errors.full_messages }, status: 422
        end
      end

      def destroy
        product = logged_user.products.find(params[:id])
        product.destroy
        head 204
      end


      private
        # Refactor this to have params for create and update...
        def product_params
          params.require(:product).permit(:name, :description, :price, :seller_id,
                                          product_images_attributes: [:img_file_name, :img_base])
        end
    end
  end
end

