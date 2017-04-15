require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  let(:seller) { FactoryGirl.create(:logged_user, preference_radius: 20_000) }

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

    context 'when pagination required' do
      let!(:products) { FactoryGirl.create_list(:product, 5, seller_id: seller.id) }

      it 'returns the specified number of products' do
        get :index, params: { user_id: seller.id, page: 1, per_page: 3 }
        expect(json_response.size).to eq(3)
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

    it 'returns the images array sorted by creation time' do
      images_ids = product.images.create(FactoryGirl.attributes_for_list(:product_image, 2)).map(&:id)
      get :show, params: { user_id: product.seller.id, id: product.id }
      response_ids = json_response[:images][-2..-1].map { |i| i[:id] }
      expect(images_ids).to eq(response_ids)
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

    context 'when pagination required' do
      it 'returns the specified number of products' do
        api_authorization_header(seller.access_token)
        get :nearby, params: { user_id: seller.id, page: 1, per_page: 2 }
        expect(json_response.size).to eq(2)
      end
    end

    it 'returns 200' do
      api_authorization_header(seller.access_token)
      get :nearby, params: { user_id: seller.id }
      is_expected.to respond_with 200
    end
  end

  describe 'POST #create' do
    let(:product_attributes) do
      product_images_attrs = FactoryGirl.attributes_for_list(:product_image, rand(1..5))
      FactoryGirl.attributes_for(:product, images_attributes: product_images_attrs)
    end

    context 'when product images are provided' do
      it 'creates the specified number of product images' do
        count_before = ProductImage.count
        images_count = product_attributes[:images_attributes].size
        api_authorization_header(seller.access_token)
        post :create, params: { user_id: seller.id, product: product_attributes }
        expect(ProductImage.count).to eq(count_before+images_count)
      end

      it 'returns 201' do
        api_authorization_header(seller.access_token)
        post :create, params: { user_id: seller.id, product: product_attributes }
        is_expected.to respond_with 201
      end
    end

    context 'when a required field is not provided' do
      it 'returns an errors array with only one message' do
        api_authorization_header(seller.access_token)
        post :create, params: { user_id: seller.id, product: product_attributes.except(:description) }
        expect(json_response[:errors].size).to eq(1)
      end

      it 'returns 422' do
        api_authorization_header(seller.access_token)
        post :create, params: { user_id: seller.id, product: product_attributes.except(:description) }
        is_expected.to respond_with 422
      end
    end

    context 'when valid fields are provided' do
      it 'returns a product owned by the corresponding seller' do
        api_authorization_header(seller.access_token)
        post :create, params: { user_id: seller.id, product: product_attributes }
        expect(json_response[:product][:seller][:id]).to eq(seller.id)
      end

      it 'returns a success field' do
        api_authorization_header(seller.access_token)
        post :create, params: { user_id: seller.id, product: product_attributes }
        expect(json_response[:success]).to be_truthy
      end
    end

    # The following two could be refactored...
    context 'when no authentication header is provided' do
      it 'returns 422' do
        post :create, params: { user_id: seller.id, product: product_attributes }
        is_expected.to respond_with 422
      end
    end

    context 'when invalid authentication header is provided' do
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
      it 'returns a success message' do
        api_authorization_header(seller.access_token)
        delete :destroy, params: { user_id: seller.id, id: old_product.id }
        expect(json_response[:success]).to be_truthy
      end
    end

    context 'when the product had many images' do
      it 'deletes all the associated images' do
        images_count = old_product.images.count
        before_delete_count = ProductImage.count
        api_authorization_header(seller.access_token)
        delete :destroy, params: { user_id: seller.id, id: old_product.id }
        expect(ProductImage.count).to eq(before_delete_count-images_count)
      end
    end
  end
end
