class Room
  attr_accessor :id, :name

  class << self
    def parse_csv
      CSV.open(rooms_csv_path).map do |row|
        generate(row)
      end
    end

    def generate(csv_row)
      data = { id: csv_row[0] }
      data[:name] = csv_row[1] if csv_row[1].present?
      self.new(data)
    end

    def rooms_csv_path
      if ENV['ENV'] == 'test'
        File.join(HipChatExporter::ROOT_PATH, 'spec/rooms.csv')
      else
        File.join(HipChatExporter::ROOT_PATH, 'rooms.csv')
      end
    end
  end

  def initialize(id:, name: nil)
    self.id = id
    self.name = name || "room_#{id}"
  end
end
