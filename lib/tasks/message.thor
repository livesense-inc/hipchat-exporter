require 'thor'

module Task
  class Message < Thor
    desc 'export', 'Export the messages to CSV files'
    method_option :force, type: :boolean, default: false, desc: 'Skip asking questions'
    def export
      unless options[:force] || yes?('Export the messages to CSV files? (y/N)', :yellow)
        return say_abort
      end

      say 'Messages are exported to CSV files'
    end

    no_commands do
      private

      def say_abort
        say 'Task is aborted'
      end
    end
  end
end
