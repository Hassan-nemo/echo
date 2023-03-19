require 'rails_helper'

RSpec.describe Endpoints::Destroy do
  let(:endpoint) { create(:endpoint) }

  subject(:execute) { described_class.execute(params) }

  describe '.context' do
    context 'when and endpoint is successfully deleted' do
      let(:params) { { id: endpoint.uuid } }

      before { endpoint }

      it 'removes the endpoint' do
        expect { execute }.to change(Endpoint, :count).by(-1)
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

    context 'when deleting endpoint raise an error' do
      let(:params) { { id: endpoint.uuid } }
      before do
        allow_any_instance_of(Endpoint).to receive(:destroy!).and_raise(ActiveRecord::ActiveRecordError)
      end

      it 'raise unprocessable error' do
        expect { execute }
          .to raise_error(UnprocessableRecord) do |error|
          expect(error.code).to eq('invalid_transaction')
          expect(error.message).to eq("Unable to Delete an endpoint with id #{params[:id]}")
        end
      end
    end
  end
end
