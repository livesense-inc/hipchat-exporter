describe Message do
  describe '.export_csv' do
    before do
      create_list(:message, 2)
    end

    after do
      FileUtils.rm_r(Dir[File.join(Message.dist_dir, '*')])
    end

    it 'exports messages to CSV files' do
      expect {
        Message.export_csv
      }.to change { Dir[File.join(Message.dist_dir, '**/messages_*.csv')].size }
    end
  end
end
