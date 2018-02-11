require 'hipchat'

module HipChat
  class Exporter
    MAX_RESULTS = 1000

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

    def fetch_room_history(room_id_or_name, from: nil, to: 'recent')
      # https://www.hipchat.com/docs/apiv2/method/view_room_history
      #
      # BOOLEAN reverse
      # Reverse the output such that the oldest message is first. For consistent paging, set to 'false'.
      # Defaults to true.

      from = from.utc if from.respond_to?(:utc)
      to = to.utc if to.respond_to?(:utc)

      @client[room_id_or_name].history(
        :'max-results' => HipChat::Exporter::MAX_RESULTS,
        timezone: nil, # To avoid 401 Error. I dont know why
        date: to,
        :'end-date' => from,
      )
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
