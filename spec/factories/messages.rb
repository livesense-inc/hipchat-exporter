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

FactoryBot.define do
  factory :message do
    sequence(:room_id) { |n| n }
    sequence(:uuid) { |n| n }
    sequence(:sender_id) { |n| n }
    sender_mention_name 'taro'
    sender_name 'YAMADA Taro'
    body 'Hello, world'
    sent_at { 1.day.ago }
  end
end