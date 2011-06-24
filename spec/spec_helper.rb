require 'bundler/setup'
Bundler.require(:default, :test)

require 'goliath/test_helper'
require './app'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.include Goliath::TestHelper, :example_group => { :file_path => /spec\/requests/ }
  config.include TimeHelper, :example_group => { :file_path => /spec\/requests/ }
end

