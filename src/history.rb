require 'json'

class History
  attr_reader :room_id, :items

  class << self
    def parse_json(file_path)
      json = JSON.load(File.open(file_path).read)

      History.new(
        room_id: File.basename(File.dirname(file_path)),
        items: json['items'],
      )
    end
  end

  def initialize(room_id:, items:)
    @room_id = room_id
    @items = items
  end
end
