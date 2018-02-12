require 'active_support'
require 'active_support/core_ext'
require 'dotenv/load'
require 'pry'

ENV['TIME_ZONE'] ||= 'Etc/UTC'
Time.zone = ENV['TIME_ZONE']

module HipChatExporter
  ROOT_PATH = File.expand_path('../', __dir__)
end

Dir[
  File.join(__dir__, '../lib/**/*.rb'),
  File.join(__dir__, '../src/**/*.rb'),
].each do |file|
  require file
end
