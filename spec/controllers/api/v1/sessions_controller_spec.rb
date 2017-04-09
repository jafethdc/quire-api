require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe 'POST #create' do

    context 'when user exists' do
      let(:user) { FactoryGirl.create(:user) }

      context 'when successfully logged in' do
        it 'renders the json for the user including the access token' do
          stub_validate_fb_user(Api::V1::SessionsController, true, email: user.email)
          post :create, params: { fb_access_token: '12345', user: { last_location: 'POINT (-78.00 12.3)' } }, format: :json
          expect(json_response[:access_token]).not_to be_nil
        end

        it 'responds with 200' do
          stub_validate_fb_user(Api::V1::SessionsController, true, email: user.email)
          post :create, params: { fb_access_token: '12345', user: { last_location: 'POINT (-78.00 12.3)' } }, format: :json
          is_expected.to respond_with 200
        end

      end
    end

    context 'when user does not exist' do
      let(:user_attributes) { FactoryGirl.attributes_for(:user).slice(:email, :last_location) }

      context 'when successfully logged in' do
        it 'renders the json for the just created user' do
          stub_validate_fb_user(Api::V1::SessionsController, true, email: user_attributes[:email])
          post :create, params: { fb_access_token: '12345', user: user_attributes.slice(:last_location) }, format: :json
          expect(json_response[:email]).to eql user_attributes[:email]
        end

        it 'renders the json for the user including the access token' do
          stub_validate_fb_user(Api::V1::SessionsController, true, email: user_attributes[:email])
          post :create, params: { fb_access_token: '12345', user: user_attributes.slice(:last_location) }, format: :json
          expect(json_response[:access_token]).not_to be_nil
        end
      end

      context 'when fb access token is invalid' do
        it 'responds with 422' do
          stub_validate_fb_user(Api::V1::SessionsController, false)
          post :create, params: { fb_access_token: '12345', user: user_attributes.slice(:last_location) }, format: :json
          is_expected.to respond_with 422
        end
      end

      context 'when a parameter is not valid' do
        it 'responds with 422' do
          stub_validate_fb_user(Api::V1::SessionsController, true, email: user_attributes[:email])
          post :create, params: { fb_access_token: '12345', user: { last_location: 'location' } }, format: :json
          is_expected.to respond_with 422
        end
      end
    end
  end


  describe 'DELETE #destroy' do
    let(:user) { FactoryGirl.create(:logged_user) }

    it 'returns a success message' do
      api_authorization_header(user.access_token)
      delete :destroy, format: :json
      expect(json_response[:success]).to be_truthy
    end

    it 'makes nil the access_token field' do
      api_authorization_header(user.access_token)
      delete :destroy, format: :json
      expect(user.reload.access_token).to be nil
    end
  end
end
