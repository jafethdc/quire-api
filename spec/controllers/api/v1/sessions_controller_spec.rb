require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe 'POST #create' do
    let(:user) { FactoryGirl.create(:user) }

    context 'when successfully created' do
      it 'renders the json representation for user just logged in' do
        stub_validate_fb_user(Api::V1::SessionsController, true, email: user.email)
        post :create, params: { fb_access_token: 'an access token' }, format: :json
        expect(json_response[:email]).to eql user.email
      end

      it 'responds with 200' do
        stub_validate_fb_user(Api::V1::SessionsController, true, email: user.email)
        post :create, params: { fb_access_token: 'an access token' }, format: :json
        is_expected.to respond_with 200
      end
    end

    context 'when user not found' do
      it 'responds with 404' do
        other_user = FactoryGirl.build(:user)
        stub_validate_fb_user(Api::V1::SessionsController, true, email: other_user.email)
        post :create, params: { fb_access_token: 'other access token' }, format: :json
        is_expected.to respond_with 404
      end
    end
  end


  describe 'POST #destroy' do
    let(:user) { FactoryGirl.create(:logged_user) }

    it 'responds with 204' do
      api_authorization_header(user.access_token)
      delete :destroy, format: :json
      is_expected.to respond_with 204
    end

    it 'makes nil the access_token field' do
      api_authorization_header(user.access_token)
      delete :destroy, format: :json
      expect(user.reload.access_token).to be nil
    end
  end
end
