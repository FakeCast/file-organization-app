require File.expand_path('../app.rb', __dir__)
require 'rspec'
require 'rack/test'
require 'factory_bot'

# Factory Bot Configuration
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
FactoryBot.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryBot.find_definitions
