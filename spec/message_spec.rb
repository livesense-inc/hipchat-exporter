describe Message do
  describe '.export_csv' do
    # TODO: save messages to DB

    after do
      FileUtils.rm_f(Message.dist_dir)
    end

    it 'exports messages to CSV files' do
      expect {
        Message.export_csv
      }.to change { Dir[File.join(Message.dist_dir, '/messages_*.csv')].size }
    end
  end
end
