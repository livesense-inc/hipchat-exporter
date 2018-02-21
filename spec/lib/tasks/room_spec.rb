describe Task::Room do
  describe '#export' do
    it 'saves rooms to DB' do
      expect {
        Task::Room.new.invoke(:export, [], force: true)
      }.to change(Room, :count)
    end
  end
end
