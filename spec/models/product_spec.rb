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

  describe '#seller' do
    it { expect(product).to validate_presence_of(:seller) }
  end

end
