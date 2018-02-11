require 'active_support'
require 'active_support/core_ext'
require 'dotenv/load'
require 'pry'

ENV['TIMEZONE'] ||= 'UTC'
Time.zone = ENV['TIMEZONE']

Dir[File.join(__dir__, '../lib/**/*.rb')].each do |file|
  require file
end
