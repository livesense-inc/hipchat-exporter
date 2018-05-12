require 'thor'

module Task
  class Message < Thor
    desc 'export', 'Export the messages to CSV files'
    method_option :force, type: :boolean, default: false, desc: 'Skip asking questions'
    def export
      unless options[:force] || yes?('Export the messages to CSV files? (y/N)', :yellow)
        return say_abort
      end

      say 'Exporting messages to CSV files ...'

      messages_count = ::Message.export_csv

      say "#{messages_count} messages are exported to CSV files"
    end

    desc 'clear', 'Remove messages CSV files'
    method_option :force, type: :boolean, default: false, desc: 'Skip asking questions'
    def clear
      unless options[:force] || yes?('Remove messages CSV files? (y/N)', :yellow)
        return say_abort
      end

      FileUtils.rm_rf(Dir[File.join(::Message.dist_dir, '*')])

      say 'Message CSV files are removed'
    end

    no_commands do
      private

      def say_abort
        say 'Task is aborted'
      end
    end
  end
end
