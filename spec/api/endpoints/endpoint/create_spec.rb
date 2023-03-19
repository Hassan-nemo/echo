require 'rails_helper'

RSpec.describe V1::Endpoints::Endpoint, 'POST /endpoints', type: :request do
  include_context 'API'

  let(:params) do
    {
      "data": {
        "type": "endpoints",
        "attributes": {
          "verb": "GET",
          "path": "/greeting",
          "response": {
            "code": 200,
            "headers": {},
            "body": "\"{ \"message\": \"Hello, world\" }\""
          }
        }
      }
    }
  end

  context 'when the request is valid' do
    it 'creates a new endpoint' do
      expect do
        post '/endpoints', params:
      end.to change(Endpoint, :count).by(1)
    end

    it 'returns the serialized endpoint' do
      post('/endpoints', params:)

      expect(response.status).to eq(201)
      expect(payload).to include(
        "data" => {
          "type" => "endpoints",
          "id" => be_present,
          "attributes" => {
            "verb" => "GET",
            "path" => "/greeting",
            "response" => {
              "code" => 200,
              "headers" => {},
              "body" => "\"{ \"message\": \"Hello, world\" }\""
            }
          }
        }
      )
    end
  end

  context 'when the request is invalid' do
    let(:params) { { data: { type: 'endpoints' } } }
    let(:expected_response) do
      {
        "errors" => [
          {
            "code" => "invalid_request",
            "detail" => "data[attributes] is missing, data[attributes][verb] is missing, "\
                        "data[attributes][path] is missing, data[attributes][response] is missing, "\
                        "data[attributes][response][code] is missing"
          }
        ]
      }
    end

    before { post '/endpoints', params: }

    it 'returns invalid request' do
      expect(response).to be_bad_request
      expect(payload).to eq(expected_response)
    end
  end

  context 'when endpoint already exist' do
    let(:params) do
      {
        "data": {
          "type": "endpoints",
          "attributes": {
            "verb": "GET",
            "path": "/greeting",
            "response": {
              "code": 200
            }
          }
        }
      }
    end

    let(:expected_response) do
      {
        "errors" => [
          {
            "detail" => "Validation failed: Path has already been taken",
            "code" => "invalid_transaction"
          }
        ]
      }
    end

    before do
      create(:endpoint)
      post '/endpoints', params:
    end

    it 'returns invalid request' do
      expect(response).to be_unprocessable
      expect(payload).to eq(expected_response)
    end
  end
end
