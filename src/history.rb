require 'hipchat'

class History
  MAX_RESULTS = 1000

  def initialize(api_token)
    @client = HipChat::Client.new(api_token)
  end

  def export(room, from: nil, to: nil)
    result_hash = { next: true, next_date_offset: to }

    loop do
      result_hash = create_room_history_file(
        room.id,
        from: from,
        to: result_hash[:next_date_offset],
      )

      break unless result_hash[:next]
    end
  end

  def create_room_history_file(room_id, from: nil, to: nil)
    file_path = file_path(room_id: room_id, timestamp: timestamp_from(to))
    FileUtils.mkdir_p(File.dirname(file_path))

    response_body = fetch_room_history(room_id, from: from, to: to)

    File.open(file_path, 'w') do |file|
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

    from = from.utc.iso8601(6) if from.respond_to?(:utc)
    to = to.utc.iso8601(6) if to.respond_to?(:utc)

    @client[room_id_or_name].history(
      :'max-results' => History::MAX_RESULTS,
      timezone: nil, # 401 Error if both timezone and end-date are set. (bug?)
      date: to,
      :'end-date' => from,
    )
  end

  def timestamp_from(time)
    begin
      # NG: Time.zone.parse(nil.to_s).to_i => 0
      Time.parse(time.to_s).to_i
    rescue
      Time.current.to_i
    end
  end

  def result_hash_from(response_body, expected_count: History::MAX_RESULTS)
    json = JSON.parse(response_body)

    if json['items'].count == expected_count
      { next: true, next_date_offset: json['items'].first['date'] }
    else
      { next: false, next_date_offset: nil }
    end
  end

  private

  def file_path(room_id:, timestamp:)
    if ENV['ENV'] == 'test'
      File.join(HipChatExporter::ROOT_PATH, "spec/tmp/rooms/#{room_id}/history_#{timestamp}.json")
    else
      File.join(HipChatExporter::ROOT_PATH, "tmp/rooms/#{room_id}/history_#{timestamp}.json")
    end
  end
end
