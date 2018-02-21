# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  room_id    :integer          not null
#  name       :string(255)      not null
#  privacy    :string(16)       not null
#  archived   :boolean          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Room < ActiveRecord::Base
  class << self
    def parse_csv!
      CSV.open(rooms_csv_path).map do |row|
        Room.find_by!(room_id: row[0].strip)
      end
    end

    def rooms_csv_path
      if ENV['ENV'] == 'test'
        File.join(HipChatExporter::ROOT_PATH, 'spec/rooms.csv')
      else
        File.join(HipChatExporter::ROOT_PATH, 'rooms.csv')
      end
    end
  end
end
