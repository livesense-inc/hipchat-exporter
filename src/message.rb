# == Schema Information
#
# Table name: messages
#
#  id                  :integer          not null, primary key
#  room_id             :integer          not null
#  uuid                :string(36)       not null
#  sender_id           :integer          not null
#  sender_mention_name :string(255)      not null
#  sender_name         :string(255)      not null
#  body                :text(65535)      not null
#  sent_at             :datetime         not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_messages_on_sent_at  (sent_at)
#  index_messages_on_uuid     (uuid) UNIQUE
#

class Message < ActiveRecord::Base
  BATCH_SIZE = 100_000

  belongs_to :room

  class << self
    def export_csv
      current = Time.current
      page = 1
      messages_count = Message.where(exported_at: nil).count

      FileUtils.mkdir_p(current_dir(current))

      Message.transaction do
        loop do
          offset = (page - 1) * Message::BATCH_SIZE
          messages = Message.includes(:room).where(exported_at: nil).order(:sent_at).offset(offset).limit(Message::BATCH_SIZE)

          CSV.open(csv_path(current_dir: current_dir(current), page: page), 'w') do |csv|
            messages.each do |message|
              csv << [message.sent_at.to_i, message.room.name, message.sender_name, message.body]
              message.update(exported_at: current)
            end
          end

          if messages.count < Message::BATCH_SIZE
            break
          else
            page += 1
          end
        end
      end

      messages_count

    rescue => exception
      FileUtils.rm_rf(current_dir(current)) if Dir.exist?(current_dir(current))
      raise exception
    end

    def dist_dir
      if ENV['ENV'] == 'test'
        File.join(HipChatExporter::ROOT_PATH, 'spec/dist')
      else
        File.join(HipChatExporter::ROOT_PATH, 'dist')
      end
    end

    private

    def current_dir(current = Time.current)
      File.join(dist_dir, current.strftime('%Y%m%d%H%M%S'))
    end

    def csv_path(current_dir:, page:)
      File.join(current_dir, "messages_#{page}.csv")
    end
  end
end
