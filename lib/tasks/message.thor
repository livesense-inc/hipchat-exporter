require 'thor'

module Task
  class Message < Thor
    desc 'export', 'Export the messages to CSV files'
    method_option :force, type: :boolean, default: false, desc: 'Skip asking questions'
    def export
      unless options[:force] || yes?('Export the messages to CSV files? (y/N)', :yellow)
        return say_abort
      end

      unless options[:force] || yes?('Remove messages CSV files before export? (y/N)', :yellow)
        return say_abort
      end

      say 'Exporting messages to CSV files ...'

      FileUtils.rm(Dir[File.join(::Message.dist_dir, 'messages_*.csv')])

      ::Message.export_csv

      say 'Messages are exported to CSV files'
    end

    desc 'clear', 'Remove messages CSV files'
    method_option :force, type: :boolean, default: false, desc: 'Skip asking questions'
    def clear
      unless options[:force] || yes?('Remove messages CSV files? (y/N)', :yellow)
        return say_abort
      end

      FileUtils.rm(Dir[File.join(::Message.dist_dir, 'messages_*.csv')])

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
