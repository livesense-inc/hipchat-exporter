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

FactoryBot.define do
  factory :room do
    name 'My room'
    privacy 'public'
    archived false
  end
end
