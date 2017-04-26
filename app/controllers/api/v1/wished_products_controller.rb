module Api
  module V1
    class WishedProductsController < ApplicationController
      before_action :authenticate_with_token, only: [:index, :create, :destroy]
      before_action :ensure_product_user_existence, only: [:create, :destroy]

      def index
        serializer = ActiveModelSerializers::SerializableResource
        wished_products = logged_user.wished_products.includes(:images)
        render json: serializer.new(wished_products, scope: logged_user).as_json, status: 200
      end

      def create
        if product_user.update wish: true
          render json: { success: true }, status: 201
        else
          render json: { success: false }, status: 422
        end
      end

      def destroy
        if product_user.update wish: false
          render json: { success: true }
        else
          render json: { success: false }
        end
      end

      private

      def ensure_product_user_existence
        pu_params = { user_id: logged_user.id, product_id: params[:id] || wished_product_params[:product_id] }
        @product_user = ProductUser.find_by pu_params
        @product_user ||= ProductUser.create pu_params
        unless @product_user.persisted?
          render json: { errors: @product_user.errors.full_messages }, status: 422
        end
      end

      def product_user
        @product_user
      end

      def wished_product_params
        params.require(:wished_product).permit(:product_id)
      end
    end
  end
end
