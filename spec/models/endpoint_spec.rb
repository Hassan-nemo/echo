require 'rails_helper'

RSpec.describe Endpoint, type: :model do
  describe 'validations' do
    subject { build(:endpoint) }

    it { is_expected.to validate_presence_of(:uuid) }
    it { is_expected.to validate_uniqueness_of(:uuid) }
    it { is_expected.to validate_presence_of(:verb) }
    it { is_expected.to validate_inclusion_of(:verb).in_array(Constants::ALLOWED_VERBS) }
    it { is_expected.to validate_presence_of(:path) }
    it { is_expected.to allow_value('/greetings').for(:path) }
    it { is_expected.not_to allow_value('/greetings?query=q').for(:path) }
    it { is_expected.to validate_presence_of(:response) }
    it { is_expected.to validate_uniqueness_of(:path).scoped_to(:verb) }
  end

  describe 'callbacks' do
    context 'when a new endpoint is created' do
      subject(:endpoint) { Endpoint.new }

      it 'generate a uuid after initialize' do
        expect(endpoint.uuid).not_to be_nil
      end
    end

    context 'when update and existing endpoint' do
      subject(:endpoint) { create(:endpoint) }

      before { endpoint }

      it 'update does not change uuid value' do
        expect do
          endpoint.update(verb: 'PUT')
        end.not_to(change { endpoint.uuid })
      end
    end
  end
  describe '#response' do
    subject(:endpoint) { build(:endpoint, response:) }

    context 'when only code present' do
      let(:response) { { 'code': 200 } }

      it { is_expected.to be_valid }
    end
    context 'when invalid code' do
      let(:response) { { 'code': 700 } }

      it { is_expected.not_to be_valid }
    end
    context 'when invalid headers' do
      let(:response) { { 'code': 200, headers: { 'Accept': 100 } } }

      it { is_expected.not_to be_valid }
    end
    context 'when invalid body' do
      let(:response) { { 'code': 200, body: 1 } }

      it { is_expected.not_to be_valid }
    end
    context 'when full valid response' do
      let(:response) do
        {
          "code": 204,
          "headers": {
            "Content-Type": 'application/json'
          },
          "body": "\"{ \"message\": \"Hello, world\" }\""
        }
      end

      it { is_expected.to be_valid }
    end
  end
end
