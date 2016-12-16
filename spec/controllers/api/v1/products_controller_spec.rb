require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  let(:seller) { FactoryGirl.create(:logged_user)  }

  describe 'GET #index' do
    context 'when there is no products' do
      it 'returns an empty array' do
        get :index, params: { user_id: seller.id }
        expect(json_response.size).to eq(0)
      end
    end

    context 'when there is 5 products' do
      it 'returns an empty array' do
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
        get :index, params: { user_id: product.seller.id, id: product.id }
        is_expected.to respond_with 200
      end
    end

    context 'when the specified user does not own the product' do
      it 'returns 404' do
        get :index, params: { user_id: 1324, id: product.id }
        is_expected.to respond_with 404
      end
    end

  end

  describe 'POST #create' do

    context 'when product images are provided' do
      let(:product_attributes) do
        product_image_attributes = FactoryGirl.attributes_for_list(:product_image,5)
        FactoryGirl.attributes_for(:product, product_images_attributes: product_image_attributes)
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

    context 'when a field is not provided' do
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

    context 'when is successfully created' do
      let(:product_attributes) { FactoryGirl.attributes_for(:product) }

      it 'returns a product owned by the corresponding seller' do
        api_authorization_header(seller.access_token)
        post :create, params: { user_id: seller.id, product: product_attributes }
        expect(json_response[:seller_id]).to eq(seller.id)
      end
    end

    # The following two could be refactored...
    context 'when no authentication header is provided' do
      let(:product_attributes) { FactoryGirl.attributes_for(:product) }

      it 'returns 404' do
        post :create, params: { user_id: seller.id, product: product_attributes }
        is_expected.to respond_with 404
      end
    end

    context 'when invalid authentication header is provided' do
      let(:product_attributes) { FactoryGirl.attributes_for(:product) }

      it 'returns 404' do
        api_authorization_header('holajejeje')
        post :create, params: { user_id: seller.id, product: product_attributes }
        is_expected.to respond_with 404
      end

    end
  end

  describe 'PUT/PATCH #update' do
    let(:old_product) { FactoryGirl.create(:product, seller_id: seller.id) }

    context 'when is successfully updated' do
      it 'changes only the specified fields' do
        api_authorization_header(seller.access_token)
        patch :update, params: { user_id: seller.id, id: old_product.id, product: { title: 'producto1' } }
        # Be more specific
        expect(json_response).not_to eq(old_product.attributes)
      end

      it 'returns 200' do
        api_authorization_header(seller.access_token)
        patch :update, params: { user_id: seller.id, id: old_product.id, product: { title: 'producto1' } }
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
