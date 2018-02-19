require 'factory_bot'

Dir[File.join(HipChatExporter::ROOT_PATH, 'spec/factories/*.rb')].each do |file|
  require file
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
