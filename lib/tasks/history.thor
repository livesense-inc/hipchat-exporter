require 'thor'

class History < Thor
  desc 'export', 'Export the history of rooms to JSON files'
  def export
    exporter = ::HipChat::Exporter.new(ENV['HIPCHAT_TOKEN'])
    exporter.create_room_history_file(1944196)
  end
end
