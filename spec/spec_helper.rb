ENV["RACK_ENV"] ||= 'test'

require File.dirname(__FILE__) + "/../application"


RSpec.configure do |config|
  config.filter_run :focus => true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true

  config.mock_with :rspec
end