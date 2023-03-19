require 'rails_helper'

RSpec.describe V1::Endpoints::Endpoint, 'PATCH /endpoints/:id', type: :request do
  include_context 'API'

  let(:endpoint) { create(:endpoint) }
  let(:params) do
    {
      "data": {
        "type": "endpoints",
        "attributes": {
          "verb": "PUT",
          "path": "/hello",
          "response": {
            "code": 201,
            "headers": { 'Content-Type' => 'application/json' },
            "body": "\"{ \"greeting\": \"Hello, world\" }\""
          }
        }
      }
    }
  end

  context 'when the endpoint exists' do
    before { patch "/endpoints/#{endpoint.uuid}", params: }

    it 'returns HTTP status 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the updated endpoint' do
      expect(payload).to include(
        'data' => {
          'type' => 'endpoints',
          'id' => endpoint.uuid,
          'attributes' => {
            'verb' => 'PUT',
            'path' => '/hello',
            'response' => {
              'code' => 201,
              'headers' => { 'Content-Type' => 'application/json' },
              'body' => "\"{ \"greeting\": \"Hello, world\" }\""
            }
          }
        }
      )
    end
  end

  context 'when the endpoint does not exist' do
    before { patch "/endpoints/not_found", params: }

    it 'returns HTTP status 404' do
      expect(response).to be_not_found
    end

    it 'returns an error message' do
      expect(payload).to include(
        'errors' => [
          {
            'code' => 'not_found',
            'detail' => "Endpoint with id not_found does not exist"
          }
        ]
      )
    end
  end

  context 'when the request is invalid' do
    let(:params) { { data: { type: 'endpoints' } } }
    let(:expected_response) do
      {
        "errors" => [
          {
            "detail" => "data[attributes] is missing, data[attributes][verb], "\
                        "data[attributes][path], data[attributes][response] are missing,"\
                        " at least one parameter must be provided",
            "code" => "invalid_request"
          }
        ]
      }
    end
    before { patch "/endpoints/#{endpoint.uuid}", params: }

    it 'returns HTTP status 422' do
      expect(response).to be_bad_request
    end

    it 'returns an error message' do
      expect(payload).to eq(expected_response)
    end
  end

  context 'when endpoint already exist' do
    let(:params) do
      {
        "data": {
          "type": "endpoints",
          "attributes": {
            "verb": "POST",
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
      create(:endpoint, verb: 'POST')
      post '/endpoints', params:
    end

    it 'returns invalid request' do
      expect(response).to be_unprocessable
      expect(payload).to eq(expected_response)
    end
  end
end
