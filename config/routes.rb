require 'api_constraints'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, is_default: true) do
      resources :users, only: [:update] do
        get '/products/nearby', to: 'products#nearby'
        resources :products do
          resources :images, controller: 'product_images', only: [:index, :create, :destroy]
        end
      end

      resources :chats, only: [:create]

      post    '/sessions', to: 'sessions#create'
      delete  '/sessions', to: 'sessions#destroy'
    end
  end
end
