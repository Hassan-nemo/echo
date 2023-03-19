require 'rails_helper'

RSpec.describe Endpoints::Index do
  subject(:execute) { described_class.execute(params) }

  context 'when no records exist' do
    let(:params) { {} }

    it 'return and empty array' do
      expect(execute).to eq([])
    end
  end
  context 'when records exists with pagination' do
    let(:params) { { page: 0, per_page: 1 } }
    let(:endpoints) do
      [
        create(:endpoint),
        create(:endpoint, verb: 'POST')
      ]
    end

    before { endpoints }

    it 'return only the first record' do
      expect(execute.pluck(:id)).to eq([endpoints.first.id])
    end
  end

  context 'when records exists without pagination params' do
    let(:params) { {} }
    let(:endpoints) do
      [
        create(:endpoint),
        create(:endpoint, verb: 'POST')
      ]
    end

    before { endpoints }

    it 'return all records (by default settings)' do
      expect(execute.pluck(:id)).to eq(endpoints.map(&:id))
    end
  end
end
