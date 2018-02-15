class Message < ActiveRecord::Base
  class << self
    def export_csv
      FileUtils.mkdir_p(dist_dir)

      CSV.open(csv_path, 'w') do |csv|
        # Because find_each method does not support order
        Message.order(:sent_at).select(:room_id, :sender_name, :body, :sent_at).each do |message|
          csv << [message.sent_at.to_i, message.room_id, message.sender_name, message.body]
        end
      end
    end

    private

    def dist_dir
      if ENV['ENV'] == 'test'
        File.join(HipChatExporter::ROOT_PATH, 'tmp/dist')
      else
        File.join(HipChatExporter::ROOT_PATH, 'dist')
      end
    end

    def csv_path(current: Time.current)
      File.join(dist_dir, "messages_#{current.to_i.to_s}#{current.usec.to_s}.csv")
    end
  end
end
