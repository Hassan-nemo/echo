require 'rails_helper'

RSpec.describe Endpoints::Create do
  subject(:execute) { described_class.execute(params) }

  describe '.execute' do
    context 'when creating a valid endpoint' do
      let(:params) do
        {
          data: {
            type: 'endpoints',
            attributes: {
              verb: 'GET',
              path: '/greeting',
              response: {
                code: 200,
                headers: {
                  "Accept" => "application/json"
                },
                body: "\"{ \"message\": \"Hello, world\" }\""
              }
            }
          }
        }
      end

      it 'add a new record to the database' do
        expect { execute }.to change(Endpoint, :count).by(1)
      end
    end

    context 'when creating invalid endpoint' do
      let(:params) do
        {
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

      it 'does not add new record' do
        expect do
          execute
        rescue StandardError
          nil
        end.not_to change(Endpoint, :count)
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
  end
end
