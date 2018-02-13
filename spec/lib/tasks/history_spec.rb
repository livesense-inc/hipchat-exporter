load 'lib/tasks/history.thor'

describe Task::History do
  describe '#export' do
    let(:rooms_dir) { File.join(HipChatExporter::ROOT_PATH, 'spec/tmp/rooms') }

    after do
      FileUtils.rm_r(rooms_dir) if File.exist?(rooms_dir)
    end

    it 'creates room history JSON files' do
      expect {
        Task::History.new.invoke(:export, [], force: true, from: '20180101', to: '20180107')
      }.to change { Dir[File.join(rooms_dir, '/*/history_*.json')].size }.by(2)
    end
  end

  describe '#clear' do
    let(:rooms_dir) { File.join(HipChatExporter::ROOT_PATH, 'spec/tmp/rooms') }

    before do
      FileUtils.mkdir_p(rooms_dir)
    end

    it 'removes rooms dir' do
      Task::History.new.invoke(:clear, [], force: true)
      expect(File.exist?(rooms_dir)).to be_falsey
    end
  end
end
