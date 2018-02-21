require 'hipchat'

class RoomExporter
  MAX_RESULTS = 1000

  attr_reader :client

  def initialize
    @client = HipChat::Client.new(ENV['HIPCHAT_TOKEN'])
  end

  def fetch
    # https://www.hipchat.com/docs/apiv2/method/get_all_rooms
    client.rooms(
      :'start-index' => 0,
      :'max-results' => RoomExporter::MAX_RESULTS,
      :'include-private' => true,
      :'include-archived' => false,
    )
  end
end
