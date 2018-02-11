require 'dotenv/load'

Dir[File.join(__dir__, '../lib/**/*.rb')].each do |file|
  require file
end
