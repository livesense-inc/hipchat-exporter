describe Message do
  describe '.export_csv' do
    before do
      create_list(:message, 2)
    end

    after do
      FileUtils.rm_rf(Dir[File.join(Message.dist_dir, '*')])
    end

    it 'exports messages to CSV files' do
      expect {
        Message.export_csv
      }.to change { Dir[File.join(Message.dist_dir, '**/messages_*.csv')].size }
    end

    it 'saves exported_at to messages' do
      expect {
        Message.export_csv
      }.to change { Message.last.exported_at }
    end

    it 'returns messages count' do
      expect(Message.export_csv).to be > 0
    end
  end
end
