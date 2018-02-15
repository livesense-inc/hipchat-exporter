require 'active_record'
require 'active_support'
require 'active_support/core_ext'
require 'colorize'
require 'dotenv/load'
require 'pry'
require 'rake'

ENV['TIME_ZONE'] ||= 'Etc/UTC'
Time.zone_default = Time.find_zone!(ENV['TIME_ZONE'])

module HipChatExporter
  ROOT_PATH = File.expand_path('../', __dir__)
end

Dir[
  File.join(__dir__, '../lib/**/*.rb'),
  File.join(__dir__, '../src/**/*.rb'),
].each do |file|
  require file
end

Dir[
  File.join(__dir__, '../lib/tasks/**/*.rake'),
  File.join(__dir__, '../lib/tasks/**/*.thor'),
].each do |file|
  load file
end

db_config_path = File.join(HipChatExporter::ROOT_PATH, 'config/database.yml')
db_config = YAML.load(ERB.new(File.read(db_config_path)).result)[ENV['ENV'] || 'default']

ActiveRecord::Base.establish_connection(db_config)
