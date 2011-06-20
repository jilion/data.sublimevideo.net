require 'bundler'

Bundler.setup
Bundler.require(:default, :test)

require 'goliath/test_helper'

# mongoid custom test setup
Mongoid.logger = nil
settings = YAML.load(ERB.new(File.new('./config/mongoid.yml').read).result)
Mongoid.from_hash(settings['test'])

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.include Goliath::TestHelper, :example_group => { :file_path => /spec\/(requests|models)/ }

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

require './app'