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
    let(:mention_name) { 'taro' }
    let(:name) { '山田太郎（YAMADA Taro）' }

    let(:item) {
      {
        "date" => "2018-01-04T10:16:02.809766+00:00",
        "from" =>
          { "id" => 5309253,
            "links" => { "self" => "https://api.hipchat.com/v2/user/5309253" },
            "mention_name" => mention_name,
            "name" => name,
            "version" => "33J960AR" },
        "id" => "5f7586a8-b71c-423c-ab11-bb2329d00201",
        "mentions" => [],
        "message" => "もう入り口あたりにいっちゃいます。エレベーターホール5Fにいます",
        "type" => "message"
      }
    }

    context 'when mention_name and name are present' do
      it 'saves a message to DB' do
        expect {
          history.save_message(item)
        }.to change(Message, :count).by(1)
      end

      it 'saves message attributes' do
        message = history.save_message(item)
        expect(message.sender_mention_name).to eq mention_name
        expect(message.sender_name).to eq name
      end
    end

    context 'when mention_name and/or name are blank' do
      let(:mention_name) { '' }
      let(:name) { '' }

      it 'saves a message to DB' do
        expect {
          history.save_message(item)
        }.to change(Message, :count).by(1)
      end

      it 'complements sender_mention_name and sender_name' do
        message = history.save_message(item)
        expect(message.sender_mention_name).to eq '(unknown)'
        expect(message.sender_name).to eq '(unknown)'
      end
    end

    context 'when same uuid message is already saved' do
      before do
        history.save_message(item)
      end

      it 'skips saving message' do
        expect {
          history.save_message(item)
        }.not_to change(Message, :count)
      end
    end
  end
end
