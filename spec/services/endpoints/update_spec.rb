require 'rails_helper'

RSpec.describe Endpoints::Update do
  subject(:execute) { described_class.execute(params) }

  describe '.execute' do
    context 'when updating a valid endpoint' do
      let(:endpoint) { create(:endpoint, :with_full_headers_and_body) }
      let(:params) do
        {
          id: endpoint.uuid,
          data: {
            type: 'endpoints',
            attributes: {
              verb: 'POST',
              path: '/hello',
              response: {
                code: 200,
                headers: {
                  "Origin" => 'http://localhost:3000'
                },
                body: "\"{ \"message\": \"Greeting\" }\""
              }
            }
          }
        }
      end

      before do
        execute
        endpoint.reload
      end

      it 'add a new record to the database' do
        expect(endpoint.verb).to eq('POST')
        expect(endpoint.path).to eq('/hello')
        expect(endpoint.response).to eq(
          {
            "body" => "\"{ \"message\": \"Greeting\" }\"",
            "code" => 200,
            "headers" => { "Origin" => "http://localhost:3000" }
          }
        )
      end
    end

    context 'when endpoint is not found' do
      let(:params) { { id: 'invalid' } }

      it 'raise not found error' do
        expect { execute }
          .to raise_error(RecordNotFound) do |error|
          expect(error.code).to eq('not_found')
          expect(error.message).to eq("Endpoint with id #{params[:id]} does not exist")
        end
      end
    end

    context 'when updating endpoint with invalid params' do
      let(:endpoint) { create(:endpoint, :with_full_headers_and_body) }

      let(:params) do
        {
          id: endpoint.uuid,
          data: {
            type: 'endpoints',
            attributes: {
              verb: 'HI',
              path: 'in valid',
              response: {
                code: 700,
                headers: {
                  "Accept" => 800
                },
                body: 900
              }
            }
          }
        }
      end

      it 'raise an error message' do
        expect { execute }
          .to raise_error(UnprocessableRecord) do |error|
          expect(error.message).to eq("Validation failed: Verb is not included in the list, "\
                                      "Path is invalid, "\
                                      "Response property '/code' is not one of: ["\
                                      "100, 101, 102, 200, 201, 202, 203, 204, 205, 206, "\
                                      "207, 208, 226, 300, 301, 302, 303, 304, 305, 306, 307, "\
                                      "308, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, "\
                                      "410, 411, 412, 413, 414, 415, 416, 417, 422, 423, 424, "\
                                      "425, 426, 428, 429, 431, 444, 451, 499, 500, 501, 502, "\
                                      "503, 504, 505, 506, 507, 508, 510, 511, 599], "\
                                      "Response property '/headers/Accept' is not of type: string, "\
                                      "Response property '/body' is not of type: string")
          expect(error.code).to eq('invalid_transaction')
        end
      end
    end

    context 'when updating endpoint raise an error' do
      let(:endpoint) { create(:endpoint) }
      let(:params) { { id: endpoint.uuid, data: { attributes: {} } } }

      before do
        allow_any_instance_of(Endpoint).to receive(:update!).and_raise(ActiveRecord::ActiveRecordError)
      end

      it 'raise unprocessable error' do
        expect { execute }
          .to raise_error(UnprocessableRecord) do |error|
          expect(error.code).to eq('invalid_transaction')
          expect(error.message).to eq("Unable to update an endpoint with params #{params}")
        end
      end
    end
  end
end
