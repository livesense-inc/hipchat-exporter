describe Room do
  describe '.parse_csv!' do
    let!(:room1) { create(:room, id: 1944196) }
    let!(:room2) { create(:room, id: 4337418) }

    it 'parse csv file and find rooms' do
      rooms = Room.parse_csv!
      expect(rooms.first).to be_an_instance_of(Room)
    end
  end
end
