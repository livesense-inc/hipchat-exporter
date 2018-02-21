require 'hipchat'

class RoomExporter
  MAX_RESULTS = 1000

  attr_reader :client

  def initialize
    @client = HipChat::Client.new(ENV['HIPCHAT_TOKEN'])
  end

  def perform
    rooms = []
    offset = 0

    loop do
      rooms += fetch(offset: offset)

      if rooms.size == RoomExporter::MAX_RESULTS
        offset += RoomExporter::MAX_RESULTS
      else
        break
      end
    end

    rooms
  end

  private

  def fetch(offset: 0)
    # https://www.hipchat.com/docs/apiv2/method/get_all_rooms
    client.rooms(
      :'start-index' => offset,
      :'max-results' => RoomExporter::MAX_RESULTS,
      :'include-private' => true,
      :'include-archived' => false,
    )
  end
end
