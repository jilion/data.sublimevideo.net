ENV["RACK_ENV"] ||= 'test'

require "bundler"
require 'bundler/setup'
Bundler.require

$LOAD_PATH.unshift("#{Dir.pwd}/lib") unless $LOAD_PATH.include?("#{Dir.pwd}/lib")

require_relative '../config.rb'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run_including focus: ENV['FOCUS'] != 'false'
  config.mock_with :rspec
  config.fail_fast = ENV['FAST_FAIL'] != 'false'
  config.order = ENV['ORDER'] || 'random'
end

require 'redis'
RSpec.configure do |config|
  config.before :each do
    Sidekiq.redis { |con| con.flushall }
  end
end
