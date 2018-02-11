require 'active_support'
require 'active_support/core_ext'
require 'dotenv/load'
require 'pry'

Dir[File.join(__dir__, '../lib/**/*.rb')].each do |file|
  require file
end
