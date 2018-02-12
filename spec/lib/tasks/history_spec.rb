load 'lib/tasks/history.thor'

describe History do
  describe '#export' do
    let(:room_id_example) { 1944196 }
    let(:room_history_dir) {
      File.join(HipChatExporter::ROOT_PATH, 'spec/tmp/rooms', room_id_example.to_s)
    }

    before do
      FileUtils.rm_r(room_history_dir) if File.exist?(room_history_dir)
    end

    after do
      FileUtils.rm_r(room_history_dir) if File.exist?(room_history_dir)
    end

    it 'Create room history CSV file' do
      expect {
        History.new.invoke(:export, [], force: true, from: '20171101', to: '20171107')
      }.to change { Dir.glob("#{room_history_dir}/*").size }.by(2)
    end
  end
end
