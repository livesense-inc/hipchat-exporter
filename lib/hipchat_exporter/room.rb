module HipChatExporter
  class Room
    attr_accessor :id, :name

    def initialize(id:, name: nil)
      self.id = id
      self.name = name || "room_#{id}"
    end
  end
end
