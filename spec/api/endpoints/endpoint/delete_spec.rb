require 'rails_helper'

RSpec.describe V1::Endpoints::Endpoint, 'DELETE /endpoints/:id', type: :request do
  include_context 'API'

  context 'when endpoint exists' do
    let(:endpoint) { create(:endpoint) }

    before { endpoint }

    it 'deletes the endpoint' do
      expect { delete "/endpoints/#{endpoint.uuid}" }.to change { Endpoint.count }.by(-1)
    end

    it 'returns 204 status code' do
      delete "/endpoints/#{endpoint.uuid}"

      expect(response.status).to eq(204)
    end

    it 'does not return a response body' do
      delete "/endpoints/#{endpoint.uuid}"

      expect(response.body).to be_blank
    end
  end

  context 'when endpoint does not exist' do
    before { delete '/endpoints/invalid' }

    it 'returns HTTP status 404' do
      expect(response).to be_not_found
    end

    it 'returns an error message' do
      expect(payload).to include(
        'errors' => [
          {
            'code' => 'not_found',
            'detail' => "Endpoint with id invalid does not exist"
          }
        ]
      )
    end
  end

  context 'when endpoint is unprocessable' do
    let(:endpoint) { create(:endpoint) }
    let(:expected_response) do
      {
        "errors" => [
          {
            "detail" => "Unable to Delete an endpoint with id #{endpoint.uuid}",
            "code" => "invalid_transaction"
          }
        ]
      }
    end

    before do
      allow_any_instance_of(Endpoint).to receive(:destroy).and_raise(ActiveRecord::RecordNotDestroyed)
      delete "/endpoints/#{endpoint.uuid}"
    end

    it 'returns a 422 status code and error message' do
      expect(response).to be_unprocessable
      expect(payload).to eq(expected_response)
    end
  end
end
