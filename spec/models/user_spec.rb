require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryGirl.build(:user) }

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:username) }
  it { is_expected.to respond_to(:full_name) }
  it { is_expected.to respond_to(:last_known_location) }
  it { is_expected.to respond_to(:access_token) }

#  it { is_expected.to be_valid }

=begin
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value('example@domain.com').for(:email) }
=end
end

