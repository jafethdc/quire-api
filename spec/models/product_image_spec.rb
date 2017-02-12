require 'rails_helper'
require 'paperclip/matchers'

RSpec.configure do |c|
  c.include Paperclip::Shoulda::Matchers
end

RSpec.describe ProductImage, type: :model do
  let(:product_image) { FactoryGirl.build(:product_image) }

  it { expect(product_image).to be_valid }

  describe '#product' do
    it { expect(product_image).to validate_presence_of(:product) }
  end

  describe '.new' do
    context 'when img_base is not provided' do
      it 'is invalid and img is invalid' do
        other_product_image = FactoryGirl.build(:product_image, img_base: nil)
        other_product_image.valid?
        expect(other_product_image.errors[:img].size).to eq(1)
      end
    end
  end

  it 'should validate :product_accepts_more_images' do
    product = FactoryGirl.create(:product)
    product.images.create(FactoryGirl.attributes_for_list(:product_image, 5-product.images.size))
    image = FactoryGirl.build(:product_image, product: product)
    image.valid?
    expect(image.errors[:product].size).to eq(1)
  end
end
