require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { FactoryGirl.build(:product) }

  it { expect(product).to be_valid }

  describe '#name' do
    it { expect(product).to validate_presence_of(:name) }
  end

  describe '#description' do
    it { expect(product).to validate_presence_of(:description) }
  end

  describe '#price' do
    it { expect(product).to validate_presence_of(:price) }
    it { expect(product).to validate_numericality_of(:price) }
  end

  describe '#images' do
    it { expect(product).to validate_length_of(:images) }
  end

  describe '#seller' do
    it { expect(product).to validate_presence_of(:seller) }
  end

  describe '#destroy' do
    it 'destroys all the associated images' do
      product = FactoryGirl.create(:product)
      images_ids = product.images.map { |i| i.id }
      product.destroy
      expect(ProductImage.where(id: images_ids)).to be_empty
    end
  end

  describe '.create' do
    it 'creates the images for the sent nested attributes' do
      images_attrs = FactoryGirl.attributes_for_list(:product_image, 3)
      product_attrs = FactoryGirl.attributes_for(:product, images_attributes: images_attrs)
      product = Product.create(product_attrs)
      expect(product.images.size).to eq(3)
    end
  end

  describe '.paginate' do
    let!(:products) { FactoryGirl.create_list(:product, 10) }

    it 'returns as many products as specified' do
      paged_products = Product.all.paginate(page: 1, per_page: 5)
      expect(paged_products.length).to eq(5)
    end

    it 'returns the right sequences of products' do
      products_sequence = Product.all.paginate(page: 1, per_page: 8)
      products_sequence1 = Product.all.paginate(page: 1, per_page: 4)
      products_sequence2 = Product.all.paginate(page: 2, per_page: 4)
      expect(products_sequence).to eq(products_sequence1+products_sequence2)
    end
  end
end

