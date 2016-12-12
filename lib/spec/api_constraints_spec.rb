require 'rails_helper'

describe ApiConstraints do
  let(:api_constraints_v1) { ApiConstraints.new(version: 1) }
  let(:api_constraints_v2) { ApiConstraints.new(version: 2, is_default: true) }

  describe 'matches?' do
    it "returns true when the version matches the 'Accept' header" do
      request = double(host: 'api.quire-api.dev', headers: { 'Accept'=>'application/vnd.quire-api.v1' })
      expect(api_constraints_v1.matches?(request)).to be true
    end

    it 'returns true when no version is provided and default is taken' do
      request = double(host: 'api.quire-api.dev')
      expect(api_constraints_v2.matches?(request)).to be true
    end

    it 'returns false when nonexistent version is provided nor its default' do
      request = double(host: 'api.quire-api.dev', headers: { 'Accept'=>'application/vnd.quire-api.v3' })
      expect(api_constraints_v1.matches?(request)).to be false
    end
  end
end