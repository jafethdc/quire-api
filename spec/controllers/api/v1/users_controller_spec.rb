require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'POST #create' do
    before(:all) do
      @test_fb_users = Koala::Facebook::TestUsers.new(  app_id: 731044283720945,
                                                        secret: 'e32e3bf7859a0208b68412775c823028')
    end

    context 'when is successfully created' do
      before(:all) do
        @test_fb_user = @test_fb_users.create(true, ['email'])
        @user_attributes = FactoryGirl.attributes_for(:user).merge(email: @test_fb_user['email'])
      end

      before(:each) do
        post :create, params: { user: @user_attributes, fb_access_token: @test_fb_user['access_token'] }, format: :json
      end

      it 'renders the json representation for the user record just created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { is_expected.to respond_with 201 }

      after(:all) do
        @test_fb_users.delete(@test_fb_user)
      end

    end

    context 'when is not created' do
      before(:all) do
        #notice I'm not including the email
        @invalid_user_attributes = FactoryGirl.attributes_for(:user).except(:email)
      end

      before(:each) do
        post :create, params: { user: @invalid_user_attributes }, format: :json
      end

      it 'renders an errors json' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it { is_expected.to respond_with 422 }
    end

    context 'when no valid fb access token is provided' do
      before(:each) do
        @invalid_user_attributes = FactoryGirl.attributes_for(:user)
        post :create, params: { user: @invalid_user_attributes }, format: :json
      end

      it 'renders an errors json' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end
    end
  end
end
