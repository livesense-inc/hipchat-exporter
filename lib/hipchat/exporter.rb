require 'hipchat'

module Hipchat
  class Exporter
    def initialize(api_token)
      @client = ::HipChat::Client.new(api_token)
    end

    def fetch_room_history(room_id_or_name)
      @client[room_id_or_name].history(date: '2018-01-01')
    end
  end
end
