require 'hipchat'

class History
  MAX_RESULTS = 1000

  attr_reader :room, :client

  def initialize(room)
    @room = room
    @client = HipChat::Client.new(ENV['HIPCHAT_TOKEN'])
  end

  def export(from: nil, to: nil)
    result_hash = { next: true, next_date_offset: to }

    loop do
      result_hash = export_part(from: from, to: result_hash[:next_date_offset])
      break unless result_hash[:next]
    end

  rescue => e
    # TODO: Improve handling exception
    message = "Caught exception: #{e.class}, room_id: #{room.id}, room_name: #{room.name}, from: #{from}, to: #{to}"

    HipChatExporter.logger.error(message)
    puts message.colorize(:red)

    HipChatExporter.logger.error(e.message)
    puts e.message.colorize(:red)

    e.backtrace.each do |row|
      HipChatExporter.logger.error(row)
    end

    if e.class == HipChat::TooManyRequests
      x_ratelimit_reset = e.response.headers['x-ratelimit-reset']

      warn_message = "X-Ratelimit-Reset: #{x_ratelimit_reset}"
      HipChatExporter.logger.warn(warn_message)
      puts warn_message.colorize(:yellow)

      warn_message = "Sleep until #{Time.zone.at(x_ratelimit_reset.to_i).to_s} and continue ..."
      HipChatExporter.logger.warn(warn_message)
      puts warn_message.colorize(:yellow)

      until Time.current.to_i > x_ratelimit_reset.to_i
        sleep 10
      end
    else
      warn_message = "Do nothing for this exception and continue ..."
      HipChatExporter.logger.warn(warn_message)
      puts warn_message.colorize(:yellow)
    end
  end

  private

  def export_part(from: nil, to: nil)
    file_path = file_path(timestamp: timestamp_from(to))
    FileUtils.mkdir_p(File.dirname(file_path))

    response_body = fetch_with_rate_limit(from: from, to: to)

    File.open(file_path, 'w') do |file|
      file.write(response_body)
    end

    result_hash_from(response_body)
  end

  def fetch_with_rate_limit(from: nil, to: nil)
    fetch(from: from, to: to)

  rescue HipChat::TooManyRequests => e
    x_ratelimit_reset = e.response.headers['x-ratelimit-reset'].to_i

    messages = [
      "Caught exception: #{e.class}, room_id: #{room.id}, room_name: #{room.name}, from: #{from}, to: #{to}",
      e.message,
      "X-Ratelimit-Reset: #{x_ratelimit_reset.to_s}",
      "Sleep until #{Time.zone.at(x_ratelimit_reset).to_s} and retry fetching ..."
    ]

    messages.each do |message|
      HipChatExporter.logger.warn(message)
      puts message.colorize(:yellow)
    end

    until Time.current.to_i > x_ratelimit_reset
      sleep 10
    end

    fetch(from: from, to: to) # retry
  end

  def fetch(from: nil, to: 'recent')
    # https://www.hipchat.com/docs/apiv2/method/view_room_history
    #
    # BOOLEAN reverse
    # Reverse the output such that the oldest message is first. For consistent paging, set to 'false'.
    # Defaults to true.

    from = utc_iso8601(from)
    to = utc_iso8601(to)

    message = "Fetching history of #{room.name} (#{room.id}), date: \"#{to}\""
    message += ", end-date: \"#{from}\"" if from.present?
    message += ", max-results: #{History::MAX_RESULTS}"

    HipChatExporter.logger.info(message)
    puts message

    client[room.id].history(
      :'max-results' => History::MAX_RESULTS,
      timezone: nil, # 401 Error if both timezone and end-date are set. (bug?)
      date: to,
      :'end-date' => from,
    )
  end

  def utc_iso8601(time)
    time.respond_to?(:utc) ? time.utc.iso8601(6) : time
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

  def file_path(timestamp:)
    if ENV['ENV'] == 'test'
      File.join(HipChatExporter::ROOT_PATH, "spec/tmp/rooms/#{room.id}/history_#{timestamp}.json")
    else
      File.join(HipChatExporter::ROOT_PATH, "tmp/rooms/#{room.id}/history_#{timestamp}.json")
    end
  end
end
