class Message < ActiveRecord::Base
  class << self
    def export_csv
      FileUtils.mkdir_p(dist_dir)

      CSV.open(csv_path, 'w') do |csv|
        # Because find_each method does not support order
        Message.order(:sent_at).pluck(:sent_at, :room_id, :sender_name, :body).each do |message|
          csv << [message[0].to_i, message[1], message[2], message[3]]
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
