describe Room do
  describe '.parse_csv' do
    it 'parse csv file and generate rooms' do
      rooms = Room.parse_csv
      expect(rooms[0].class).to eq Room
    end
  end

  describe '.generate' do
    let(:room) { Room.generate(csv_row) }

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
      let(:room) { Room.new(id: 123, name: 'My Room') }

      it { expect(room.id).to eq 123 }
      it { expect(room.name).to eq 'My Room' }
    end

    context 'when name not exist' do
      let(:room) { Room.new(id: 123) }

      it { expect(room.id).to eq 123 }
      it { expect(room.name).to eq 'room_123' }
    end
  end
end
