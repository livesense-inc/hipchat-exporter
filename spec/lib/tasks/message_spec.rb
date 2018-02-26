describe Task::Message do
  describe '#export' do
    before do
      create_list(:message, 2)
    end

    after do
      FileUtils.rm_rf(Dir[File.join(Message.dist_dir, '*')])
    end

    it 'exports messages to CSV files' do
      expect {
        Task::Message.new.invoke(:export, [], force: true)
      }.to change { Dir[File.join(Message.dist_dir, '**/messages_*.csv')].size }
    end
  end
end
