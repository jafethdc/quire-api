require 'rails_helper'

RSpec.describe Api::V1::ProductImagesController, type: :controller do
  let(:seller) { FactoryGirl.create(:logged_user) }
  let(:product) { FactoryGirl.create(:product, seller_id: seller.id) }


  describe 'GET #index' do
    it "renders a json object with all the product's images" do
      FactoryGirl.create_list(:product_image, 5, product_id: product.id)
      get :index, params: { user_id: seller.id, product_id: product.id }
      expect(json_response.size).to eq(product.product_images.count)
    end

    it 'returns 200' do
      get :index, params: { user_id: seller.id, product_id: product.id }
      is_expected.to respond_with 200
    end
  end

  describe 'POST #create' do

    context 'when is successfully created' do
      let(:product_image_attrs) { FactoryGirl.attributes_for(:product_image) }

      it 'renders a json object with the passed fields' do
        api_authorization_header(seller.access_token)
        post :create, params: { product_image:  product_image_attrs,
                                product_id:     product.id,
                                user_id:        seller.id  }
        expect(json_response[:img_file_name]).to eq(product_image_attrs[:img_file_name])
      end

      it 'returns 201' do
        api_authorization_header(seller.access_token)
        post :create, params: { product_image:  product_image_attrs,
                                product_id:     product.id,
                                user_id:        seller.id  }
        is_expected.to respond_with 201
      end
    end

    context 'when img_base is not provided' do
      let(:product_image_attrs) { FactoryGirl.attributes_for(:product_image).except(:img_base) }

      it 'returns 422' do
        api_authorization_header(seller.access_token)
        post :create, params: { product_image:  product_image_attrs,
                                product_id:     product.id,
                                user_id:        seller.id  }
        is_expected.to respond_with 422
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when is successfully destroyed' do
      let(:product_image) { FactoryGirl.create(:product_image, product_id: product.id) }

      it 'returns 204' do
        api_authorization_header(seller.access_token)
        delete :destroy, params: { id:          product_image.id,
                                   product_id:  product.id,
                                   user_id:     seller.id }
        is_expected.to respond_with 204
      end
    end
  end
end
