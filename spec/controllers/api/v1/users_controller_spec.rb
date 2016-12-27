require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'POST #create' do
    context 'when valid parameters are passed' do
      it 'renders the json representation for the user record just created' do
        user_attributes = FactoryGirl.attributes_for(:user)
        stub_validate_fb_user(Api::V1::UsersController, true)
        post :create, params: { user: user_attributes, fb_access_token: 'an access token' }, format: :json
        expect(json_response[:email]).to eql user_attributes[:email]
      end

      it 'responds with 201' do
        user_attributes = FactoryGirl.attributes_for(:user)
        stub_validate_fb_user(Api::V1::UsersController, true)
        post :create, params: { user: user_attributes, fb_access_token: 'an access token' }, format: :json
        is_expected.to respond_with 201
      end

    end

    context 'when an invalid parameter is sent' do
      it 'renders an errors json' do
        user_attributes = FactoryGirl.attributes_for(:user, username: nil)
        stub_validate_fb_user(Api::V1::UsersController, true)
        post :create, params: { user: user_attributes, fb_access_token: 'an access token' }, format: :json
        expect(json_response).to have_key(:errors)
      end

      it 'responds with 422' do
        user_attributes = FactoryGirl.attributes_for(:user, username: nil)
        stub_validate_fb_user(Api::V1::UsersController, true)
        post :create, params: { user: user_attributes, fb_access_token: 'an access token' }, format: :json
        is_expected.to respond_with 422
      end
    end

    context 'when no valid fb access token is provided' do
      it 'renders an errors json' do
        invalid_user_attributes = FactoryGirl.attributes_for(:user)
        post :create, params: { user: invalid_user_attributes }, format: :json
        expect(json_response).to have_key(:errors)
      end

      it 'responds with 422' do
        invalid_user_attributes = FactoryGirl.attributes_for(:user)
        post :create, params: { user: invalid_user_attributes }, format: :json
        is_expected.to respond_with 422
      end
    end
  end

  describe 'PUT/PATCH #update' do
    let(:user) { FactoryGirl.create(:logged_user) }

    context 'when the value(s) to update are valid' do
      it 'returns a json with the updated user' do
        api_authorization_header(user.access_token)
        patch :update, params: { id: user.id, user: { username: 'jafethdiazc' } }, format: :json
        expect(json_response[:username]).to eql('jafethdiazc')
      end

      it 'responds with 200' do
        api_authorization_header(user.access_token)
        patch :update, params: { id: user.id, user: { last_location: 'POINT (-12.0647631 -76.9470219)' } }, format: :json
        is_expected.to respond_with 200
      end
    end

    context 'when invalid values are sent' do
      it 'returns a json with the error(s)' do
        api_authorization_header(user.access_token)
        patch :update, params: { id: user.id, user: { last_location: 'POINT (hola jeje)' } }, format: :json
        expect(json_response).to have_key(:errors)
      end

      it 'responds with 422' do
        api_authorization_header(user.access_token)
        patch :update, params: { id: user.id, user: { last_location: 'POINT (hola jeje)' } }, format: :json
        is_expected.to respond_with 422
      end
    end

    context 'when the user id does not match the access token' do
      let(:other_user) { FactoryGirl.create(:logged_user) }

      it 'the operation is aborted' do
        api_authorization_header(user.access_token)
        patch :update, params: { id: other_user.id, user: { username: 'pepito123' } }, format: :json
        expect(user.reload.username).not_to eq('pepito123')
      end

      it 'responds with 401' do
        api_authorization_header(user.access_token)
        patch :update, params: { id: other_user.id, user: { username: 'pepito123' } }, format: :json
        is_expected.to respond_with 401
      end
    end
  end
end
