describe Message do
  describe '.export_csv' do
    let(:dist_dir) { Message.send(:dist_dir) }

    # TODO: save messages to DB

    it 'exports messages to CSV files' do
      expect {
        Message.export_csv
      }.to change { Dir[File.join(dist_dir, '/messages_*.csv')].size }
    end
  end
end
