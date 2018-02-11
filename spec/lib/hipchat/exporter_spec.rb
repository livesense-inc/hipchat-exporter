describe Hipchat::Exporter do
  let(:exporter) { Hipchat::Exporter.new(ENV['HIPCHAT_TOKEN']) }

  describe '.root_path' do
    it { expect(Hipchat::Exporter.root_path).to eq File.expand_path('../../..', __dir__) }
  end

  describe '#fetch_room_history' do
    let(:room_id_example) { 1944196 }

    it 'Get JSON response body' do
      response_body = exporter.fetch_room_history(room_id_example)
      json = JSON.parse(response_body)

      expect(json['items']).not_to be_empty
    end
  end
end
