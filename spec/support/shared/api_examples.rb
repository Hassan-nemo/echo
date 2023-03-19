shared_context 'API' do
  let(:payload) { JSON.parse(response.body) }
end
