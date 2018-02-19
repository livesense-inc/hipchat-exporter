describe Task::History do
  describe '#export' do
    after do
      FileUtils.rm_r(Dir[File.join(History.rooms_dir, '*')])
    end

    context 'when theads option is NOT set' do
      it 'creates room history JSON files' do
        expect {
          Task::History.new.invoke(:export, [], force: true, from: '20180101', to: '20180107')
        }.to change { Dir[File.join(History.rooms_dir, '**/history_*.json')].size }.by(2)
      end
    end

    context 'when theads option is set' do
      it 'creates room history JSON files' do
        expect {
          Task::History.new.invoke(:export, [], force: true, from: '20180101', to: '20180107', threads: 2)
        }.to change { Dir[File.join(History.rooms_dir, '**/history_*.json')].size }.by(2)
      end
    end
  end

  describe '#clear' do
    let(:room_dir) { File.join(History.rooms_dir, '1234567') }

    before do
      FileUtils.mkdir_p(room_dir)
    end

    it 'removes rooms dir' do
      Task::History.new.invoke(:clear, [], force: true)
      expect(File.exist?(room_dir)).to be_falsey
    end
  end

  describe '#save' do
    let(:room_dir) { File.join(History.rooms_dir, '1234567') }

    let(:fixture_history_json_path) {
      File.join(HipChatExporter::ROOT_PATH, 'spec/fixtures/rooms/1234567/history_1234567890.json')
    }

    before do
      FileUtils.mkdir_p(room_dir)
      FileUtils.cp_r(fixture_history_json_path, File.join(room_dir, 'history_1234567890.json'))
    end

    it 'saves room history to database' do
      expect {
        Task::History.new.invoke(:save, [], force: true)
      }.to change(Message, :count)
    end
  end
end
