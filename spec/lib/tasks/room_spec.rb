describe Task::Room do
  describe '#export' do
    it 'saves rooms to DB' do
      expect {
        Task::Room.new.invoke(:export, [], force: true)
      }.to change(Room, :count)
    end
  end

  describe '#map' do
    let!(:room1) { create(:room, name: 'My rooom') }

    it 'say room id list' do
      expect {
        Task::Room.new.invoke(:map, [], force: true)
      }.not_to raise_error
    end
  end
end
