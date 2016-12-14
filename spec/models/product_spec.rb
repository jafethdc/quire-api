require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { FactoryGirl.build(:product) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:price) }
  it { is_expected.to respond_to(:seller) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price) }
  it { is_expected.to validate_presence_of(:seller) }

end
