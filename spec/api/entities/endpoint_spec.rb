require 'rails_helper'

RSpec.describe V1::Entities::Endpoint do
  let(:endpoint) { create(:endpoint, :with_full_headers_and_body) }

  describe '#serializable_hash' do
    subject(:entity) { described_class.new(endpoint).serializable_hash }

    it 'has the correct metadata' do
      expect(entity[:data][:type]).to eq(:endpoints)
      expect(entity[:data][:id]).to eq(endpoint.uuid)
    end

    it 'has the correct attributes' do
      expect(entity[:data][:attributes]).to eq({
                                                 verb: endpoint.verb,
                                                 path: endpoint.path,
                                                 response: endpoint.response
                                               })
    end
  end
end
