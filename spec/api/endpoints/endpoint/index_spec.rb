require 'rails_helper'

RSpec.describe V1::Endpoints::Endpoint, 'GET /endpoints', type: :request do
  include_context 'API'
  let(:endpoint1) { create(:endpoint) }
  let(:endpoint2) { create(:endpoint, verb: 'POST') }
  let(:endpoints) { [endpoint1, endpoint2] }

  before { endpoints }

  context 'when the request is successful without pagination' do
    before { get '/endpoints' }

    it 'returns a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'returns a collection of endpoints' do
      expect(payload['data']).to be_an(Array)
      expect(payload['data'].size).to eq(2)
      expect(payload['data'].map { |el| el['type'] }.uniq).to eq(['endpoints'])
    end

    it 'includes the endpoint attributes in the response' do
      expect(payload['data'].map { |el| el['id'] }).to eq(endpoints.pluck(:uuid))
    end
  end

  context 'when pagination parameters are provided' do
    before { get '/endpoints', params: { page: 0, per_page: 1 } }

    it 'returns the requested page of results' do
      expect(payload['data'].size).to eq(1)
      expect(payload['data'][0]['id']).to eq(endpoint1.uuid)
    end
  end
end
