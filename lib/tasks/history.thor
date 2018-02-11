require 'thor'

class History < Thor
  desc 'export', 'Export the history of rooms to JSON files'
  method_option :from, type: :string
  method_option :to, type: :string

  def export
    from = options[:from] ? Time.parse(options[:from]) : nil
    to = options[:to] ? Time.parse(options[:to]).end_of_day : Time.current

    exporter = ::HipChat::Exporter.new(ENV['HIPCHAT_TOKEN'])
    exporter.create_room_history_file_list(1944196, from: from, to: to)
  end
end
