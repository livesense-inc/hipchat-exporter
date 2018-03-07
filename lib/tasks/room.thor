require 'thor'

module Task
  class Room < Thor
    desc 'export', 'Export rooms and save them to DB'
    method_option :force, type: :boolean, default: false, desc: 'Skip asking questions'
    def export
      unless options[:force] || yes?('Export rooms and save them to DB? (y/N)', :yellow)
        return say_abort
      end

      RoomExporter.new.perform
      say 'Room data are saved to DB'
    end

    desc 'map', 'Map room names in CSV file and room ids in DB'
    method_option :force, type: :boolean, default: false, desc: 'Skip asking questions'
    def map
      csv_data = CSV.read(room_names_csv_path, headers: false)
      csv_data.each do |row|
        room_name = row[0]
        if room = ::Room.find_by(name: room_name)
          say room.id
        else
          say room_name, :yellow
        end
      end
    end

    no_commands do
      private

      def say_abort
        say 'Task is aborted'
      end

      def room_names_csv_path
        if ENV['ENV'] == 'test'
          File.join(HipChatExporter::ROOT_PATH, 'spec/room_names.csv')
        else
          File.join(HipChatExporter::ROOT_PATH, 'room_names.csv')
        end
      end
    end
  end
end
