require 'hipchat'

module HipChat
  class Exporter
    def self.root_path
      File.expand_path('../..', __dir__)
    end

    def initialize(api_token)
      @client = ::HipChat::Client.new(api_token)
    end

    def create_room_history_file(room_id_or_name)
      FileUtils.mkdir_p(File.dirname(room_history_file_path(room_id_or_name)))

      response_body = fetch_room_history(room_id_or_name)

      File.open(room_history_file_path(room_id_or_name), 'w') do |file|
        file.write(response_body)
      end

      room_history_file_path(room_id_or_name)
    end

    def fetch_room_history(room_id_or_name)
      @client[room_id_or_name].history
    end

    def room_history_file_path(room_id_or_name)
      if ENV['ENV'] == 'test'
        File.join(HipChat::Exporter.root_path, "spec/tmp/rooms/#{room_id_or_name}/history.json")
      else
        File.join(HipChat::Exporter.root_path, "tmp/rooms/#{room_id_or_name}/history.json")
      end
    end
  end
end
