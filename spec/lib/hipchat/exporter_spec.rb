describe HipChat::Exporter do
  let(:exporter) { HipChat::Exporter.new(ENV['HIPCHAT_TOKEN']) }

  describe '.root_path' do
    it { expect(HipChat::Exporter.root_path).to eq File.expand_path('../../..', __dir__) }
  end

  describe '#create_room_history_file' do
    let(:room_id_example) { 1944196 }
    let(:room_history_dir) {
      File.join(HipChat::Exporter.root_path, 'spec/tmp/rooms', room_id_example.to_s)
    }

    before do
      FileUtils.rm_r(room_history_dir) if File.exist?(room_history_dir)
    end

    after do
      FileUtils.rm_r(room_history_dir) if File.exist?(room_history_dir)
    end

    it 'Create room history CSV file' do
      expect {
        exporter.create_room_history_file(room_id_example)
      }.to change { Dir.glob("#{room_history_dir}/*").size }.by(1)
    end
  end

  describe '#fetch_room_history' do
    let(:room_id_example) { 1944196 }
    let(:from) { Time.zone.local(2018, 1, 1) }
    let(:to) { Time.zone.local(2018, 1, 2) }

    it 'Get JSON response body' do
      response_body = exporter.fetch_room_history(room_id_example, from: from, to: to)
      json = JSON.parse(response_body)

      expect(json['items']).to be_present
      expect(json['items'].count < HipChat::Exporter::MAX_RESULTS).to be_truthy
    end
  end
end
