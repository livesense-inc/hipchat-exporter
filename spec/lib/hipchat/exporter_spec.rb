describe Hipchat::Exporter do
  let(:exporter) { Hipchat::Exporter.new(ENV['HIPCHAT_TOKEN']) }

  describe '#fetch_room_history' do
    let(:room_id_example) { 1944196 }
    it { expect(exporter.fetch_room_history(room_id_example)).to be_truthy }
  end
end
