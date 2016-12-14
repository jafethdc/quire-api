require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do
    before(:all) do
      @test_fb_users = Koala::Facebook::TestUsers.new(  app_id: 731044283720945,
                                                        secret: 'e32e3bf7859a0208b68412775c823028')
      @test_fb_user = @test_fb_users.create(true, ['email'])
      @user = User.create(FactoryGirl.attributes_for(:user, email: @test_fb_user['email']))
    end

    context 'when successfully created' do
      before(:each) do
        post :create, params: { access_token: @test_fb_user['access_token'] }, format: :json
      end

      it 'renders the json representation for user just logged in' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @user.email
      end

      it { is_expected.to respond_with 200 }
    end

    context 'when user not found' do
      before(:each) do
        @other_test_fb_user = @test_fb_users.create(true, ['email'])
        post :create, params: { access_token: @other_test_fb_user['access_token'] }, format: :json
      end

      it { is_expected.to respond_with 404 }

      after(:each) do
        @test_fb_users.delete(@other_test_fb_user)
      end
    end

    after(:all) do
      @user.destroy
      @test_fb_users.delete(@test_fb_user)
    end
  end


  describe 'POST #destroy' do
    before(:all) do
      @user = User.create(FactoryGirl.attributes_for(:user).merge(access_token: SecureRandom.base58(24)))
    end

    before(:each) do
      delete :destroy, params: { user: { access_token: @user.access_token } }, format: :json
    end

    it { is_expected.to respond_with 204 }

    it 'makes nil the access_token field' do
      @user.reload
      expect(@user.access_token).to be nil
    end
  end
end
