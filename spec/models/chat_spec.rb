require 'rails_helper'

RSpec.describe Chat, type: :model do
  let(:chat) { FactoryGirl.build :chat }

  it { expect(chat).to be_valid }

  describe '#product' do
    it { expect(chat).to validate_presence_of(:product) }
  end

  describe '#creator' do
    it { expect(chat).to validate_presence_of(:creator) }
  end

  describe '#url' do
    it { expect(chat).to validate_presence_of(:url) }
  end
end
