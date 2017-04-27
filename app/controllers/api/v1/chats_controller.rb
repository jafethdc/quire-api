module Api
  module V1
    class ChatsController < ApplicationController
      before_action :authenticate_with_token, only: [:create]
      before_action :ensure_product_user_existence, only: [:create]

      def create
        chat = Chat.new(chat_params.merge(creator_id: logged_user.id))
        if chat.save
          product_user.update(skip: true)
          render json: chat, status: 201
        else
          product_user.update(skip: false)
          render json: { errors: chat.errors.full_messages }, status: 422
        end
      end

      private

      def chat_params
        params.require(:chat).permit(:product_id, :url)
      end

      def ensure_product_user_existence
        pu_params = { user_id: logged_user.id, product_id: chat_params[:product_id] }
        @product_user = ProductUser.find_by pu_params
        @product_user ||= ProductUser.create pu_params
        unless @product_user.persisted?
          render json: { errors: @product_user.errors.full_messages }, status: 422
        end
      end

      def product_user
        @product_user
      end
    end
  end
end
