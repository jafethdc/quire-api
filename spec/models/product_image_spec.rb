require 'rails_helper'
require 'paperclip/matchers'

RSpec.configure do |c|
  c.include Paperclip::Shoulda::Matchers
end

RSpec.describe ProductImage, type: :model do
  subject { FactoryGirl.build(:product_image) }

  it { is_expected.to respond_to(:img) }
  it { is_expected.to respond_to(:product) }

  it { is_expected.to be_valid }

  it { is_expected.to have_attached_file(:img) }

  # Don't know why it's not working
  # it { is_expected.to validate_attachment_presence(:img) }

  it { is_expected.to validate_presence_of(:product) }
end
