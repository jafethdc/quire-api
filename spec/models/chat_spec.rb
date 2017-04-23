require 'rails_helper'

RSpec.describe Chat, type: :model do
  let(:chat) { FactoryGirl.build :chat }

  it { expect(chat).to be_valid }

  describe '#product' do
    it { expect(chat).to validate_presence_of(:product) }
  end

  describe '#creator' do
    it { expect(chat).to validate_presence_of(:creator) }

    it 'validates the members are different' do
      chat.creator = chat.product.seller
      expect(chat).not_to be_valid
    end
  end

  describe '#url' do
    it { expect(chat).to validate_presence_of(:url) }
  end
end
