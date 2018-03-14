# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  privacy    :string(16)       not null
#  archived   :boolean          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Room < ActiveRecord::Base
  has_many :messages

  class << self
    def parse_csv!
      CSV.open(rooms_csv_path).map { |row|
        Room.find(row[0].strip) if row[0].present?
      }.compact
    end

    def rooms_csv_path
      if ENV['ENV'] == 'test'
        File.join(HipChatExporter::ROOT_PATH, 'spec/rooms.csv')
      else
        File.join(HipChatExporter::ROOT_PATH, 'rooms.csv')
      end
    end
  end

  def name_for_slack
    _name = self.name.gsub(/[\(\)\/<>＜＞:;（）【】@＠・⇔\&＆\s　›´ω`‹๑•̀ㅁ•́๑✧Φ+＋−⇄~〜↗︎]/, '-')
    _name = _name.gsub(/[＿]/, '_')
    _name = _name.gsub(/\-+/, '-')
    _name = _name.gsub(/\A\-+/, '')
    _name = _name.gsub(/\-+\z/, '')
    _name
  end
end
