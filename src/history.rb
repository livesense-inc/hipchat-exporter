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

  def save_messages
    items.each do |item|
      save_message(item)
    end
  end

  def save_message(item)
    Message.find_or_create_by(uuid: item['id']) do |message|
      message.room_id = self.room_id
      message.sender_mention_name = item['from']['mention_name'].presence || '(somebody)'
      message.sender_name = item['from']['name'].presence || '(somebody)'
      message.body = item['message'].presence || '(blank)'
      message.sent_at = item['date']
    end
  end
end
