require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe 'POST #create' do
    let(:user) { FactoryGirl.create(:user) }

    context 'when successfully created' do
      it 'renders the json for the user including the access token' do
        stub_validate_fb_user(Api::V1::SessionsController, true, email: user.email)
        post :create, params: { fb_access_token: 'an access token' }, format: :json
        expect(json_response[:access_token]).not_to be_nil
      end

      it 'responds with 200' do
        stub_validate_fb_user(Api::V1::SessionsController, true, email: user.email)
        post :create, params: { fb_access_token: 'an access token' }, format: :json
        is_expected.to respond_with 200
      end
    end

    context 'when user not found' do
      let(:user_attributes) { FactoryGirl.attributes_for(:user).slice(:email, :last_location) }
      it 'renders the json for the created user' do
        stub_validate_fb_user(Api::V1::SessionsController, true, email: user_attributes[:email])
        post :create, params: { fb_access_token: 'an access token', user: user_attributes }, format: :json
        expect(json_response[:email]).to eql user_attributes[:email]
      end

      it 'renders the json for the user including the access token' do
        stub_validate_fb_user(Api::V1::SessionsController, true, email: user_attributes[:email])
        post :create, params: { fb_access_token: 'an access token', user: user_attributes }, format: :json
        expect(json_response[:access_token]).not_to be_nil
      end
    end
  end


  describe 'DELETE #destroy' do
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
