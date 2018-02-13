require 'erb'
require 'yaml'

namespace :db do
  db_config_path = File.join(HipChatExporter::ROOT_PATH, 'config/database.yml')
  db_config = YAML.load(ERB.new(File.read(db_config_path)).result)[ENV['ENV'] || 'default']
  db_config_admin = db_config.merge({ 'database' => 'mysql' })

  desc "Create the database"
  task :create do
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.create_database(db_config['database'])
    puts "Database #{db_config['database']} created"
  end

  desc "Drop the database"
  task :drop do
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.drop_database(db_config['database'])
    puts "Database #{db_config['database']} deleted"
  end
end
