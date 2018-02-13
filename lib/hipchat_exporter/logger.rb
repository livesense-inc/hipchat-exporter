require 'logger'

module HipChatExporter
  def self.logger
    @logger ||= Logger.new(log_path)
  end

  def self.log_path
    if ENV['ENV'] == 'test'
      File.join(HipChatExporter::ROOT_PATH, 'log/test.log')
    else
      File.join(HipChatExporter::ROOT_PATH, 'log/default.log')
    end
  end
end
