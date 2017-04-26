require 'rails_helper'

RSpec.describe Api::V1::SkippedProductsController, type: :controller do
  let!(:user) { FactoryGirl.create(:logged_user) }
  let!(:product) { FactoryGirl.create(:product) }

  describe 'POST #create' do
    it 'returns a success field' do
      api_authorization_header(user.access_token)
      post :create, params: { skipped_product: { product_id: product.id } }
      expect(json_response[:success]).to be_truthy
    end

    context 'when a productuser does not exist' do

      context 'when product and user are valid' do
        it 'creates the productuser' do
          product_user_count = ProductUser.count
          api_authorization_header(user.access_token)
          post :create, params: { skipped_product: { product_id: product.id } }
          expect(ProductUser.count).to eq(product_user_count + 1)
        end
      end

      context 'when product and user are not valid' do
        it 'returns an errors messages array' do
          api_authorization_header(user.access_token)
          bad_product = FactoryGirl.create(:product, seller_id: user.id)
          post :create, params: { skipped_product: { product_id: bad_product.id } }
          expect(json_response[:errors].size).to eq(1)
        end
      end
    end
  end
end
