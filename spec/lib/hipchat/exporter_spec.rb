describe Hipchat::Exporter do
  let(:exporter) { Hipchat::Exporter.new(ENV['HIPCHAT_TOKEN']) }

  describe '.root_path' do
    it { expect(Hipchat::Exporter.root_path).to eq File.expand_path('../../..', __dir__) }
  end

  describe '#create_room_history_file' do
    let(:room_id_example) { 1944196 }
    let(:room_history_dir) {
      File.join(Hipchat::Exporter.root_path, 'tmp/rooms', room_id_example.to_s)
    }

    it 'Create room history CSV file' do
      expect {
        exporter.create_room_history_file(room_id_example)
      }.to change { Dir.glob("#{room_history_dir}/*").size }.by(1)
    end
  end

  describe '#fetch_room_history' do
    let(:room_id_example) { 1944196 }

    it 'Get JSON response body' do
      response_body = exporter.fetch_room_history(room_id_example)
      json = JSON.parse(response_body)

      expect(json['items']).to be_present
    end
  end
end
