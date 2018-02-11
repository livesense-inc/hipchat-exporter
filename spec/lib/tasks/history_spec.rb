load 'lib/tasks/history.thor'

describe History do
  describe '#export' do
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
        History.new.invoke(:export)
      }.to change { Dir.glob("#{room_history_dir}/*").size }.by(1)
    end
  end
end
