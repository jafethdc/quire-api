require 'rails_helper'

RSpec.describe Api::V1::WishedProductsController, type: :controller do
  let!(:user) { FactoryGirl.create(:logged_user) }
  let!(:products) { FactoryGirl.create_list(:product, 5) }

  describe 'GET #index' do
    it 'returns the wished products' do
      3.times.each { |i| FactoryGirl.create(:product_user, user_id: user.id, product_id: products[i].id, wish: true) }
      api_authorization_header(user.access_token)
      get :index, params: { user_id: user.id }
      expect(json_response.size).to eq(3)
    end
  end

  describe 'POST #create' do
    it 'returns a success field' do
      api_authorization_header(user.access_token)
      post :create, params: { wished_product: { product_id: products.sample.id } }
      expect(json_response[:success]).to be_truthy
    end

    context 'when a productuser does not exist' do

      context 'when product and user are valid' do
        it 'creates the productuser' do
          product_user_count = ProductUser.count
          api_authorization_header(user.access_token)
          post :create, params: { wished_product: { product_id: products.sample.id } }
          expect(ProductUser.count).to eq(product_user_count + 1)
        end
      end

      context 'when product and user are not valid' do
        it 'returns an errors messages array' do
          api_authorization_header(user.access_token)
          product = FactoryGirl.create(:product, seller_id: user.id)
          post :create, params: { wished_product: { product_id: product.id } }
          expect(json_response[:errors].size).to eq(1)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'returns a success field' do
      product_user = FactoryGirl.create(:product_user, user_id: user.id)
      api_authorization_header(user.access_token)
      delete :destroy, params: { id: product_user.product.id }
      expect(json_response[:success]).to be_truthy
    end
  end
end
