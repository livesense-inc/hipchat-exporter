describe History do
  let(:room_id) { 1944196 }
  let(:room) { Room.new(id: room_id) }
  let(:history) { History.new(room) }
  let(:history_dir) { File.join(HipChatExporter::ROOT_PATH, 'spec/tmp/rooms', room_id.to_s) }

  describe '#export' do
    let(:from) { Time.zone.local(2017, 11, 1) }
    let(:to) { Time.zone.local(2017, 11, 7).end_of_day }

    after do
      FileUtils.rm_r(history_dir)
    end

    it 'exports room history to JSON files' do
      expect {
        history.export(from: from, to: to)
      }.to change { Dir[File.join(history_dir, 'history_*.json')].size }
    end
  end

  describe '#export_file' do
    let(:from) { Time.zone.local(2018, 1, 1) }
    let(:to) { Time.zone.local(2018, 1, 2).end_of_day }

    after do
      FileUtils.rm_r(history_dir)
    end

    it 'exports room history to JSON file' do
      expect {
        history.send(:export_partially, from: from, to: to)
      }.to change { Dir[File.join(history_dir, 'history_*.json')].size }
    end
  end

  describe '#fetch' do
    let(:from) { Time.zone.local(2018, 1, 1) }
    let(:to) { Time.zone.local(2018, 1, 2).end_of_day }

    it 'gets JSON response body' do
      response_body = history.send(:fetch, from: from, to: to)
      json = JSON.parse(response_body)

      expect(json['items']).to be_present
      expect(json['items'].count < History::MAX_RESULTS).to be_truthy
    end
  end

  describe '#timezone_from' do
    subject { history.send(:timestamp_from, time) }

    context 'when time class is Time (or TimeWithZone)' do
      let(:time) { Time.zone.local(2018, 2, 1) }
      it { is_expected.to be > 1_000_000_000 }
    end

    context 'when time class is String' do
      let(:time) { '2018-01-01T01:23:45.123456+00:00' }
      it { is_expected.to be > 1_000_000_000 }
    end

    context 'when time is nil' do
      let(:time) { nil }
      it { is_expected.to be > 1_000_000_000 }
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

    subject { history.send(:result_hash_from, response_body, expected_count: expected_count) }

    context 'when messages count == expected_count' do
      let(:expected_count) { 2 }
      it { is_expected.to eq({ next: true, next_date_offset: message_date1 }) }
    end

    context 'when messages count < expected_count' do
      let(:expected_count) { 3 }
      it { is_expected.to eq({ next: false, next_date_offset: nil }) }
    end
  end
end
