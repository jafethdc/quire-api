require 'spec_helper'

describe ApiConstraints do
  let(:api_constraints_v1) { ApiConstraints.new(version: 1) }
  let(:api_constraints_v2) { ApiConstraints.new(version: 2, default: true) }

  describe 'matches?' do
    it "returns true when the version matches the 'Accept' header" do
      request = double(host: 'api.quire-api.dev', headers: { 'Accept'=>'application/vnd.quire-api.v1' })
      api_constraints_v1.matches?(request).should be_true
    end

    it 'returns true when no version is provided and default is taken' do
      request = double(host: 'api.quire-api.dev')
      api_constraints_v2.matches?(request).should be_true
    end
  end
end