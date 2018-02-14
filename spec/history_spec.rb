describe History do
  describe '.parse_json' do
    let(:history_json_path) {
      File.join(HipChatExporter::ROOT_PATH, 'spec/fixtures/rooms/1234567/history_1234567890.json')
    }

    it 'parses json file and generate history instance' do
      history = History.parse_json(history_json_path)

      expect(history.class).to eq History
      expect(history.room_id).to eq '1234567'
      expect(history.items).to be_present
    end
  end
end
