describe HipChatExporter::Room do
  describe '.parse_csv' do
    it 'parse csv file and generate rooms' do
      rooms = HipChatExporter::Room.parse_csv
      expect(rooms[0].class).to eq HipChatExporter::Room
    end
  end

  describe '.generate' do
    let(:room) { HipChatExporter::Room.generate(csv_row) }

    context 'when name exists' do
      let(:csv_row) { [123, 'My Room'] }

      it { expect(room.id).to eq 123 }
      it { expect(room.name).to eq 'My Room' }
    end

    context 'when name not exist' do
      let(:csv_row) { [123] }

      it { expect(room.id).to eq 123 }
      it { expect(room.name).to eq 'room_123' }
    end
  end

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
