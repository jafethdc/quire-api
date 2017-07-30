module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_with_token, only: [:create, :update, :destroy, :nearby]
      before_action only: [:create, :update, :destroy, :nearby] { match_token_with_user(:user_id) }

      def index
        user = User.find(params[:user_id])
        products = user.products.paginate(paginate_params).includes(:images)
        render json: products, status: 200
      end

      def show
        user = User.find(params[:user_id])
        product = user.products.find(params[:id])
        render json: product, status: 200
      end

      def nearby
        serializer = ActiveModelSerializers::SerializableResource
        nearby_products = logged_user.nearby_products.includes(:images).shuffle
        render json: serializer.new(nearby_products, scope: logged_user).as_json, status: 200
      end

      def create
        product = logged_user.products.build(product_params)
        if product.save
          render json: { success: true, product: ProductSerializer.new(product).as_json }, status: 201
        else
          render json: { success: false, errors: product.errors.full_messages }, status: 422
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
        if product.destroyed?
          render json: { success: true }
        else
          render json: { success: false }
        end
      end

      private

      # Refactor this to have params for create and update...
      def product_params
        params.require(:product).permit(:name, :description, :price, :seller_id,
                                        images_attributes: [:img_base])
      end

      def paginate_params
        { page: params[:page], per_page: params[:per_page] }
      end
    end
  end
end

