describe Room do
  describe '.parse_csv!' do
    let!(:room1) { create(:room, id: 1944196) }
    let!(:room2) { create(:room, id: 4337418) }

    it 'parses csv file and find rooms' do
      rooms = Room.parse_csv!
      expect(rooms.all? { |room| room.class == Room }).to be_truthy
    end
  end

  describe '#name_for_slack' do
    let(:room) { build(:room, name: name) }

    subject { room.name_for_slack }

    context 'when name includes ()' do
      let(:name) { 'MyRoom(foo)' }
      it { is_expected.to eq 'MyRoom-foo-' }
    end
  end
end
