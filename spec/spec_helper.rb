require 'bundler'
Bundler.setup
Bundler.require(:default, :test)

require 'goliath/test_helper'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.include Goliath::TestHelper, :example_group => { :file_path => /spec\/(requests|models)/ }
end

require './app'