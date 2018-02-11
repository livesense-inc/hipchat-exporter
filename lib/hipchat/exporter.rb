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

    def create_room_history_file(room_id_or_name, from: nil, to: nil)
      timestamp = timestamp_from(to)

      room_history_file_path = room_history_file_path(
        room_id_or_name: room_id_or_name,
        timestamp: timestamp,
      )

      FileUtils.mkdir_p(File.dirname(room_history_file_path))

      response_body = fetch_room_history(room_id_or_name, from: from, to: to)

      File.open(room_history_file_path, 'w') do |file|
        file.write(response_body)
      end

      result_hash_from(response_body)
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

    def timestamp_from(time)
      begin
        Time.zone.parse(time.to_s).to_i
      rescue
        Time.current.to_i
      end
    end

    def room_history_file_path(room_id_or_name:, timestamp:)
      if ENV['ENV'] == 'test'
        File.join(HipChat::Exporter.root_path, "spec/tmp/rooms/#{room_id_or_name}/history_#{timestamp}.json")
      else
        File.join(HipChat::Exporter.root_path, "tmp/rooms/#{room_id_or_name}/history_#{timestamp}.json")
      end
    end

    def result_hash_from(response_body, expected_count: HipChat::Exporter::MAX_RESULTS)
      json = JSON.parse(response_body)

      if json['items'].count == expected_count
        { next: true, next_date_offset: json['items'].first['date'] }
      else
        { next: false, next_date_offset: nil }
      end
    end
  end
end
