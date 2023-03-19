require 'rails_helper'

RSpec.describe Endpoints::Resolve do
  subject(:execute) { described_class.execute(params) }

  context 'when record exists' do
    let(:endpoint) { create(:endpoint) }
    let(:params) { { verb: 'GET', path: '/greeting' } }

    before { endpoint }

    it 'returns the matching endpoint' do
      expect(execute.id).to eq(endpoint.id)
    end
  end

  context 'when record does not exist' do
    let(:params) { { verb: 'GET', path: '/greeting' } }

    it 'raise not found error' do
      expect { execute }
        .to raise_error(RecordNotFound) do |error|
        expect(error.code).to eq('not_found')
        expect(error.message).to eq("Requested page `#{params[:path]}` does not exist")
      end
    end
  end
end
