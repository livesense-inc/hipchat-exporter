describe HipChat::Exporter do
  let(:exporter) { HipChat::Exporter.new(ENV['HIPCHAT_TOKEN']) }

  describe '.root_path' do
    it { expect(HipChat::Exporter.root_path).to eq File.expand_path('../../..', __dir__) }
  end

  describe '#create_room_history_file' do
    let(:room_id_example) { 1944196 }
    let(:from) { Time.zone.local(2018, 1, 1) }
    let(:to) { Time.zone.local(2018, 1, 2) }

    let(:room_history_dir) {
      File.join(HipChat::Exporter.root_path, 'spec/tmp/rooms', room_id_example.to_s)
    }

    before do
      FileUtils.rm_r(room_history_dir) if File.exist?(room_history_dir)
    end

    after do
      FileUtils.rm_r(room_history_dir) if File.exist?(room_history_dir)
    end

    it 'Create room history JSON file' do
      expect {
        exporter.create_room_history_file(room_id_example, from: from, to: to)
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

  describe '#result_hash_from' do
    let(:message_date1) { '2018-01-01T01:23:45.123456+00:00' }
    let(:message_date2) { '2018-02-14T01:23:45.123456+00:00' }

    let(:message1) { { "date": message_date1, "message": "foo", "type": "message" } }
    let(:message2) { { "date": message_date2, "message": "bar", "type": "message" } }

    let(:response_body) {
      {
        items: [
          message1,
          message2,
        ]
      }.to_json
    }

    subject { exporter.result_hash_from(response_body, expected_count: expected_count) }

    context 'When messages count == expected_count' do
      let(:expected_count) { 2 }
      it { is_expected.to eq({ next: true, next_date_offset: message_date1 }) }
    end

    context 'When messages count < expected_count' do
      let(:expected_count) { 3 }
      it { is_expected.to eq({ next: false, next_date_offset: nil }) }
    end
  end
end
