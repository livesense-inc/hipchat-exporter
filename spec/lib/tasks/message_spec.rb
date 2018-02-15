describe Task::Message do
  describe '#export' do
    it 'raises no error' do
      expect {
        Task::Message.new.invoke(:export, [], force: true)
      }.not_to raise_error
    end
  end
end
