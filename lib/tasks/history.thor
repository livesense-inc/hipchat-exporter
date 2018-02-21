require 'thor'
require 'parallel'

module Task
  class History < Thor
    desc 'export', 'Export the history of rooms to JSON files'
    method_option :from, type: :string, desc: 'Date (or Time) like "20180101"'
    method_option :to, type: :string, desc: 'Date (or Time), like "20180131", default is Time.current'
    method_option :threads, type: :numeric, desc: 'Threads count for speedup blocking operations'
    method_option :force, type: :boolean, default: false, desc: 'Skip asking questions'
    def export
      unless options[:force] || yes?("Export the history of rooms to JSON files? (y/N)", :yellow)
        return say_abort
      end

      if options[:from]
        from = Time.parse(options[:from])
        unless options[:force] || yes?("\"from\" option is set to \"#{from.to_s}\", OK? (y/N)", :yellow)
          return say_abort
        end
      else
        from = nil
        unless options[:force] || yes?("\"from\" option is NOT set, OK? (y/N)", :yellow)
          return say_abort
        end
      end

      if options[:to]
        to = Time.parse(options[:to]).end_of_day
        unless options[:force] || yes?("\"to\" option is set to \"#{to.to_s}\", OK? (y/N)", :yellow)
          return say_abort
        end
      else
        to = Time.current
        unless options[:force] || yes?("\"to\" option is NOT set, OK? (y/N)", :yellow)
          return say_abort
        end
      end

      rooms = ::Room.parse_csv!

      if options[:threads]
        Parallel.each(rooms, in_threads: options[:threads]) do |room|
          export_room(room, from: from, to: to)
        end
      else
        rooms.each do |room|
          export_room(room, from: from, to: to)
        end
      end
    end

    desc 'clear', 'Remove room history JSON files'
    method_option :force, type: :boolean, default: false, desc: 'Skip asking questions'
    def clear
      unless options[:force] || yes?("Remove room history JSON files? (y/N)", :yellow)
        return say_abort
      end

      FileUtils.rm_r(rooms_dir) if File.exist?(rooms_dir)
      say 'Room history JSON files are removed'
    end

    desc 'save', 'Save the history of rooms to DB'
    method_option :force, type: :boolean, default: false, desc: 'Skip asking questions'
    def save
      unless options[:force] || yes?("Save the history of rooms to DB? (y/N)", :yellow)
        return say_abort
      end

      Dir[File.join(rooms_dir, '**/history_*.json')].each do |history_json_path|
        history = ::History.parse_json(history_json_path)
        HipChatExporter.logger.info("Saving history of #{history.room_id}, #{File.basename(history_json_path)}", with_put: true)
        history.save_messages
      end

      say 'History of rooms are saved to DB'
    end

    no_commands do
      private

      def export_room(room, from:, to:)
        message = "Exporting history of #{room.name} (#{room.id}) ..."
        HipChatExporter.logger.info(message, with_put: true, color: :cyan)

        exporter = ::HistoryExporter.new(room)
        exporter.perform(from: from, to: to)
      end

      def say_abort
        say 'Task is aborted'
      end

      def rooms_dir
        if ENV['ENV'] == 'test'
          File.join(HipChatExporter::ROOT_PATH, 'spec/tmp/rooms')
        else
          File.join(HipChatExporter::ROOT_PATH, 'tmp/rooms')
        end
      end
    end
  end
end
