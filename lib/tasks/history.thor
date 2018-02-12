require 'thor'

module Task
  class History < Thor
    desc 'export', 'Export the history of rooms to JSON files'
    method_option :from, type: :string
    method_option :to, type: :string
    method_option :force, type: :boolean, default: false
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
        to = nil
        unless options[:force] || yes?("\"to\" option is NOT set, OK? (y/N)", :yellow)
          return say_abort
        end
      end

      exporter = Exporter.new(ENV['HIPCHAT_TOKEN'])

      Room.parse_csv.each do |room|
        exporter.create_room_history_file_list(room.id, from: from, to: to)
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
