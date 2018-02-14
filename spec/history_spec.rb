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

  describe '#save_message' do
    let(:history) { History.new(room_id: '1234567', items: []) }
    let(:item) {
      {
        "date" => "2018-01-04T10:16:02.809766+00:00",
        "from" =>
          { "id" => 5309253,
            "links" => { "self" => "https://api.hipchat.com/v2/user/5309253" },
            "mention_name" => "micchie",
            "name" => "白川 みちる(Michiru Shirakawa)",
            "version" => "33J960AR" },
        "id" => "5f7586a8-b71c-423c-ab11-bb2329d00201",
        "mentions" => [],
        "message" => "もう入り口あたりにいっちゃいます。エレベーターホール5Fにいます",
        "type" => "message"
      }
    }

    it 'saves a message to DB' do
      expect {
        history.save_message(item)
      }.to change(Message, :count).by(1)
    end
  end
end
