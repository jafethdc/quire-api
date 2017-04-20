module Api
  module V1
    class ChatsController < ApplicationController
      before_action :authenticate_with_token, only: [:create]

      def create
        chat = Chat.new(chat_params)
        if chat.save
          render json: chat, status: 201
        else
          render json: { errors: chat.errors.full_messages }, status: 422
        end
      end

      private

      def chat_params
        params.require(:chat).permit(:creator_id, :product_id, :url)
      end
    end
  end
end
