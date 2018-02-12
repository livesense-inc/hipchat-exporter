describe HipChatExporter::Room do
  describe 'initialize' do
    context 'when name exists' do
      let(:room) { HipChatExporter::Room.new(id: 123, name: 'My Room') }

      it { expect(room.id).to eq 123 }
      it { expect(room.name).to eq 'My Room' }
    end

    context 'when name not exist' do
      let(:room) { HipChatExporter::Room.new(id: 123) }

      it { expect(room.id).to eq 123 }
      it { expect(room.name).to eq 'room_123' }
    end
  end
end
