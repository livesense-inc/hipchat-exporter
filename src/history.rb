require 'json'

class History
  attr_reader :messages

  class << self
    def parse_json(file_path)
      json = JSON.load(File.open(file_path).read)
      History.new(json['items'])
    end
  end

  def initialize(messages)
    @messages = messages
  end
end
