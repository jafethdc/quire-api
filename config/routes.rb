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

      scope '/me' do
        resources :wished_products, only: [:index, :create, :destroy]

        post '/skipped_products', to: 'skipped_products#create'
        post '/chats', to: 'chats#create'
      end

      post    '/sessions', to: 'sessions#create'
      delete  '/sessions', to: 'sessions#destroy'
    end
  end
end
