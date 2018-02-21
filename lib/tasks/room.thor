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

    no_commands do
      private

      def say_abort
        say 'Task is aborted'
      end
    end
  end
end
