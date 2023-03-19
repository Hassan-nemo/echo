require 'rails_helper'

RSpec.describe V1::Endpoints::Mock, type: :request do
  include_context 'API'

  context 'when endpoint does exits' do
    let(:endpoint) { create(:endpoint, :with_full_headers_and_body) }

    before do
      endpoint

      get '/greeting'
    end

    it 'return the stored status code' do
      expect(response.status).to eq(endpoint.response['code'])
    end
    it 'return the stored body' do
      expect(payload).to eq(endpoint.response['body'])
    end
    it 'return the stored headers' do
      expect(response.headers).to eq(response.headers)
    end
  end
  context 'when endpoint does not exist' do
    before { get '/not_implemented' }

    it 'return not found response' do
      expect(response).to be_not_found
      expect(payload).to eq(
        "errors" => [
          {
            "code" => "not_found",
            "detail" => "Requested page `/not_implemented` does not exist"
          }
        ]
      )
    end
  end
end
