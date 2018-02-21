describe RoomExporter do
  let(:exporter) { RoomExporter.new }

  describe '#perform' do
    it 'gets HipChat::Room array' do
      rooms = exporter.perform

      expect(rooms.size).to be > RoomExporter::MAX_RESULTS
      expect(rooms.first).to be_an_instance_of(HipChat::Room)
    end
  end

  describe '#fetch' do
    it 'gets HipChat::Room array' do
      rooms = exporter.send(:fetch)
      room = rooms.first

      expect(rooms.size).to be > 1
      expect(room).to be_an_instance_of(HipChat::Room)
      expect(room.room_id).to be > 0
      expect(room.name).to be_present
      expect(room.privacy).to match(/\A(private|public)\z/)
      expect(room.respond_to?(:is_archived)).to be_truthy
    end
  end
end
