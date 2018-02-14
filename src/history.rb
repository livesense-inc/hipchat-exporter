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
    sender_mention_name =
      if item['from']['mention_name'].present?
        item['from']['mention_name']
      else
        'somebody'
      end

    sender_name =
      if item['from']['name'].present?
        item['from']['name']
      else
        'somebody'
      end

    Message.create(
      room_id: self.room_id,
      uuid: item['id'],
      sender_mention_name: sender_mention_name,
      sender_name: sender_name,
      body: item['message'],
      sent_at: item['date'],
    )
  end
end
