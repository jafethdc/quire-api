require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }

  it { expect(user).to be_valid }

  describe '#email' do
    it { expect(user).to validate_presence_of(:email) }
    it { expect(user).to validate_uniqueness_of(:email).case_insensitive }
    it { expect(user).to allow_value('example@domain.com').for(:email) }
    it { expect(user).not_to allow_value('examplexdomain.com').for(:email) }
  end

  describe '#fb_user_id' do
    it { expect(user).to validate_presence_of(:fb_user_id) }
  end

  describe '#name' do
    it { expect(user).to validate_presence_of(:name) }
  end

  describe '#preference_radius' do
    it { expect(user).to validate_numericality_of(:preference_radius) }
    it { expect(user).to validate_presence_of(:preference_radius) }
  end

  describe '.new' do
    context 'when no preference radius is provided' do
      it 'sets a default preference radius' do
        # The user factory does not provide a preference radius field
        user = FactoryGirl.build(:user)
        expect(user.preference_radius).not_to be_nil
      end
    end

    context 'when preference radius is provided' do
      it 'sets the value provided' do
        user = FactoryGirl.build(:user, preference_radius: 20000)
        expect(user.preference_radius).to eq(20000)
      end
    end
  end

  describe '#nearby_users' do
    it 'returns the user located within a given radius' do
      user = FactoryGirl.create(:user)
      FactoryGirl.create_list(:user, 2, last_location: rand_point_within(user.last_location, user.preference_radius))
      expect(user.nearby_users.size).to eq(2)
    end
  end

  describe '#nearby_products' do
    it "returns the nearby users' products" do
      user = FactoryGirl.create(:user)
      nearby_users = FactoryGirl.create_list(:user, 2, last_location: rand_point_within(user.last_location,
                                                                                        user.preference_radius))
      FactoryGirl.create_list(:product, 3, seller_id: nearby_users.first.id)
      FactoryGirl.create_list(:product, 2, seller_id: nearby_users.second.id)
      expect(user.nearby_products.size).to eq(5)
    end
  end

  describe '#destroy' do
    it "destroys all the user's products" do
      user = FactoryGirl.create(:user)
      products_ids = FactoryGirl.create_list(:product, 3, seller_id: user.id).map(&:id)
      user.destroy
      expect(Product.where(id: products_ids)).to be_empty
    end
  end
end

