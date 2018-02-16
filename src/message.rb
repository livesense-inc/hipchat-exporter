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

class Message < ActiveRecord::Base
  BATCH_SIZE = 100_000

  class << self
    def export_csv
      FileUtils.mkdir_p(dist_dir)

      page = 1

      loop do
        offset = (page - 1) * Message::BATCH_SIZE
        messages = Message.order(:sent_at).offset(offset).limit(Message::BATCH_SIZE)

        CSV.open(csv_path(page), 'w') do |csv|
          messages.pluck(:sent_at, :room_id, :sender_name, :body).each do |message|
            csv << [message[0].to_i, "room_#{message[1]}", message[2], message[3]]
          end
        end

        if messages.count < Message::BATCH_SIZE
          break
        else
          page += 1
        end
      end
    end

    def dist_dir
      if ENV['ENV'] == 'test'
        File.join(HipChatExporter::ROOT_PATH, 'spec/dist')
      else
        File.join(HipChatExporter::ROOT_PATH, 'dist')
      end
    end

    private

    def csv_path(page)
      File.join(dist_dir, "messages_#{page}.csv")
    end
  end
end
