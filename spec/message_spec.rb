describe Message do
  let(:message) { build(:message) }

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

  describe '#from_bot?' do
    context 'sender_name is unknown' do
      let(:message) { build(:message, sender_name: 'unknown') }
      it { expect(message.from_bot?).to be_truthy }
    end

    context 'sender_name is NOT unknown' do
      let(:message) { build(:message, sender_name: 'somebody') }
      it { expect(message.from_bot?).to be_falsey }
    end

    it 'returns sent_at as YYYY-MM' do
      expect(message.ym).to match /\A\d{4}-\d{2}\z/
    end
  end

  describe '#reaction?' do
    context 'body is reaction' do
      let(:message) { build(:message, body: "(yeah)\n") }
      it { expect(message.reaction?).to be_truthy }
    end

    context 'body is NOT reaction' do
      let(:message) { build(:message, body: 'Hello, world') }
      it { expect(message.reaction?).to be_falsey }
    end
  end

  describe '#ym' do
    it 'returns sent_at as YYYY-MM' do
      expect(message.ym).to match /\A\d{4}-\d{2}\z/
    end
  end
end
