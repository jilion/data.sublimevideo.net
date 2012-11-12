ENV["RACK_ENV"] ||= 'test'

require File.dirname(__FILE__) + "/../application.rb"

require 'goliath/test_helper'

RSpec.configure do |config|
  config.include Goliath::TestHelper
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run_including focus: true
  config.mock_with :rspec
  config.fail_fast = ENV['FAST_FAIL'] != 'false'
  config.order = 'random'
end
