require 'rails_helper'

RSpec.describe ProductUser, type: :model do
  let(:product_user) { FactoryGirl.create(:product_user) }

  it { expect(product_user).to be_valid }

  describe '#user' do
    it { expect(product_user).to validate_presence_of(:user) }
  end

  describe '#product' do
    it { expect(product_user).to validate_presence_of(:product) }
  end

  it "validates #product's owner is not #user" do
    product_user.user = product_user.product.seller
    expect(product_user).not_to be_valid
  end
end

