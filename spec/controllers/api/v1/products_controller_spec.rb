require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  let(:seller) { FactoryGirl.create(:logged_user, preference_radius: 20000)  }

  describe 'GET #index' do
    context 'when there is no products' do
      it 'returns an empty array' do
        get :index, params: { user_id: seller.id }
        expect(json_response.size).to eq(0)
      end
    end

    context 'when there are 5 products' do
      it 'returns a size-5 array' do
        FactoryGirl.create_list(:product, 5, seller_id: seller.id)
        get :index, params: { user_id: seller.id }
        expect(json_response.size).to eq(5)
      end
    end

    it 'returns 200' do
      get :index, params: { user_id: seller.id }
      is_expected.to respond_with 200
    end
  end

  describe 'GET #show' do
    let(:product) { FactoryGirl.create(:product) }

    context 'when the specified user owns the product' do
      it 'returns 200' do
        get :show, params: { user_id: product.seller.id, id: product.id }
        is_expected.to respond_with 200
      end
    end

    context 'when the specified user does not own the product' do
      it 'returns 404' do
        other_seller = FactoryGirl.create(:user)
        get :show, params: { user_id: other_seller.id, id: product.id }
        is_expected.to respond_with 404
      end
    end
  end

  describe 'GET #nearby' do
    let!(:user) { FactoryGirl.create(:logged_user, last_location: rand_point_within(seller.last_location, seller.preference_radius)) }
    let!(:product_list) { FactoryGirl.create_list(:product, 3, seller_id: user.id) }
    let!(:user2) { FactoryGirl.create(:logged_user, last_location: rand_point_within(seller.last_location, seller.preference_radius + 4000)) }
    let!(:product_list2) { FactoryGirl.create_list(:product, 4, seller_id: user2.id) }

    it 'returns the products within the right area' do
      api_authorization_header(seller.access_token)
      get :nearby, params: { user_id: seller.id }
      expect(json_response.size).to  be >= product_list.size
    end

    context 'when some users get closer' do
      it 'returns more products within the right area' do
        user2.update_attribute('last_location', rand_point_within(seller.last_location, seller.preference_radius))
        api_authorization_header(seller.access_token)
        get :nearby, params: { user_id: seller.id }
        expect(json_response.size).to eq(product_list.size+product_list2.size)
      end
    end

    it 'returns 200' do
      api_authorization_header(seller.access_token)
      get :nearby, params: { user_id: seller.id }
      is_expected.to respond_with 200
    end
  end

  describe 'POST #create' do

    context 'when product images are provided' do
      let(:product_attributes) do
        product_image_attributes = FactoryGirl.attributes_for_list(:product_image, 5)
        FactoryGirl.attributes_for(:product, images_attributes: product_image_attributes)
      end

      it 'creates 5 new product images' do
        count_before = ProductImage.count
        api_authorization_header(seller.access_token)
        post :create, params: { user_id: seller.id, product: product_attributes }
        expect(ProductImage.count).to eq(count_before+5)
      end

      it 'returns 201' do
        api_authorization_header(seller.access_token)
        post :create, params: { user_id: seller.id, product: product_attributes }
        is_expected.to respond_with 201
      end
    end

    context 'when a required field is not provided' do
      let(:product_attributes) { FactoryGirl.attributes_for(:product).except(:description) }

      it 'returns an errors array with only one message' do
        api_authorization_header(seller.access_token)
        post :create, params: { user_id: seller.id, product: product_attributes }
        expect(json_response[:errors].size).to eq(1)
      end

      it 'returns 422' do
        api_authorization_header(seller.access_token)
        post :create, params: { user_id: seller.id, product: product_attributes }
        is_expected.to respond_with 422
      end
    end

    context 'when valid fields are provided' do
      let(:product_attributes) { FactoryGirl.attributes_for(:product) }

      it 'returns a product owned by the corresponding seller' do
        api_authorization_header(seller.access_token)
        post :create, params: { user_id: seller.id, product: product_attributes }
        expect(json_response[:seller][:id]).to eq(seller.id)
      end
    end

    # The following two could be refactored...
    context 'when no authentication header is provided' do
      let(:product_attributes) { FactoryGirl.attributes_for(:product) }

      it 'returns 422' do
        post :create, params: { user_id: seller.id, product: product_attributes }
        is_expected.to respond_with 422
      end
    end

    context 'when invalid authentication header is provided' do
      let(:product_attributes) { FactoryGirl.attributes_for(:product) }

      it 'returns 422' do
        api_authorization_header('holajejeje')
        post :create, params: { user_id: seller.id, product: product_attributes }
        is_expected.to respond_with 422
      end
    end
  end

  describe 'PUT/PATCH #update' do
    let(:old_product) { FactoryGirl.create(:product, seller_id: seller.id) }

    context 'when is successfully updated' do
      it 'changes only the specified fields' do
        api_authorization_header(seller.access_token)
        patch :update, params: { user_id: seller.id, id: old_product.id, product: { name: 'producto1' } }
        expect(json_response[:name]).not_to eq(old_product.name)
      end

      it 'returns 200' do
        api_authorization_header(seller.access_token)
        patch :update, params: { user_id: seller.id, id: old_product.id, product: { name: 'producto1' } }
        is_expected.to respond_with 200
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:old_product) { FactoryGirl.create(:product, seller_id: seller.id) }

    context 'when is successfully destroyed' do
      it 'returns 204' do
        api_authorization_header(seller.access_token)
        delete :destroy, params: { user_id: seller.id, id: old_product.id }
        is_expected.to respond_with 204
      end
    end

    context 'when the product had many images' do
      it 'deletes all the associated images' do
        FactoryGirl.create_list(:product_image, 5, product_id: old_product.id)
        before_delete_count = ProductImage.count
        api_authorization_header(seller.access_token)
        delete :destroy, params: { user_id: seller.id, id: old_product.id }
        expect(ProductImage.count).to eq(before_delete_count-5)
      end
    end
  end
end
