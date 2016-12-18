require 'api_constraints'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:create] do
        resources :products do
          resources :product_images, only: [:index, :create, :destroy]
        end
        get '/products/nearby', to: 'products#nearby'
      end

      post    '/sessions', to: 'sessions#create'
      delete  '/sessions', to: 'sessions#destroy'
    end
  end
end
