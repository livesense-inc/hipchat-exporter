require 'colorize'
require 'logger'

module HipChatExporter
  class Logger < ::Logger
    def info(message, with_put: false, color: nil)
      super(message)
      puts_with_color(message, color: color) if with_put
    end

    def warn(message, with_put: false, color: :yellow)
      super(message)
      puts_with_color(message, color: color) if with_put
    end

    def error(message, with_put: false, color: :red)
      super(message)
      puts_with_color(message, color: color) if with_put
    end

    private

    def puts_with_color(message, color: nil)
      if color
        puts message.colorize(color)
      else
        puts message
      end
    end
  end

  def self.logger
    @logger ||= HipChatExporter::Logger.new(log_path)
  end

  def self.log_path
    if ENV['ENV'] == 'test'
      File.join(HipChatExporter::ROOT_PATH, 'log/test.log')
    else
      File.join(HipChatExporter::ROOT_PATH, 'log/default.log')
    end
  end
end
