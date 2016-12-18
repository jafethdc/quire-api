require 'rails_helper'
require 'paperclip/matchers'

RSpec.configure do |c|
  c.include Paperclip::Shoulda::Matchers
end

RSpec.describe ProductImage, type: :model do
  let(:product_image) { FactoryGirl.create(:product_image) }

  it 'is valid with valid attributes' do
    expect(product_image).to be_valid
  end

  it { expect(product_image).to validate_presence_of(:product) }

  context 'when img_base is not provided' do
    it 'is invalid' do
      test_product_image = FactoryGirl.build(:product_image, img_base: nil)
      test_product_image.valid?
      expect(test_product_image.errors[:img].size).to eq(1)
    end
  end

end
