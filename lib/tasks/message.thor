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

    desc 'stats', 'Stats of messages'
    method_option :room_id, type: :numeric, desc: 'Target room id', required: true
    def stats
      result = {}

      ::Message.where(room_id: options[:room_id]).find_each do |message|
        next if message.from_bot?
        next if message.body.blank?

        if result[message.ym]
          if message.reaction?
            result[message.ym][:reaction] += 1
          else
            result[message.ym][:message] += 1
          end
        else
          result[message.ym] = { message: 0, reaction: 0 }
        end
      end

      result.sort.each do |ym, count|
        puts "#{ym} => { message: #{count[:message]}, reaction: #{count[:reaction]}, sum: #{count[:message] + count[:reaction]} }"
      end

      result.sort.each do |ym, count|
        puts "#{ym}, #{count[:message]}, #{count[:reaction]}, #{count[:message] + count[:reaction]}"
      end
    end

    no_commands do
      private

      def say_abort
        say 'Task is aborted'
      end
    end
  end
end
