ENV["RACK_ENV"] ||= 'test'

require File.dirname(__FILE__) + '/../application.rb'

require 'goliath/test_helper'
require 'sidekiq/testing'

require_relative 'config/rspec'

RSpec.configure do |config|
  config.include Goliath::TestHelper

  config.before do
    with_api(Application) do |a|
      Sidekiq.redis { |r| r.flushall }
      stop
    end
  end
end
