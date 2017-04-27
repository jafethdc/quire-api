require 'rails_helper'

RSpec.describe Api::V1::ChatsController, type: :controller do
  let(:creator) { FactoryGirl.create(:logged_user) }
  let(:product) { FactoryGirl.create(:product) }

  describe 'POST #create' do
    context 'when all parameters are valid' do
      it 'returns 201' do
        attrs = { product_id: product.id }.merge(FactoryGirl.attributes_for(:chat))
        api_authorization_header(creator.access_token)
        post :create, params: { chat: attrs }
        is_expected.to respond_with 201
      end

      it 'returns the just created chat object' do
        attrs = { product_id: product.id }.merge(FactoryGirl.attributes_for(:chat))
        api_authorization_header(creator.access_token)
        post :create, params: { chat: attrs }
        expect(json_response[:url]).to_not be_nil
      end

      it "sets the productuser's skip flag to true" do
        attrs = { product_id: product.id }.merge(FactoryGirl.attributes_for(:chat))
        api_authorization_header(creator.access_token)
        post :create, params: { chat: attrs }
        product_user = ProductUser.find_by(product_id: product.id, user_id: creator.id)
        expect(product_user.skip).to be_truthy
      end
    end
  end
end
