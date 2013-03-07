ENV["RACK_ENV"] ||= 'test'

require 'sidekiq'
require 'sidekiq/testing'

require_relative 'config/rspec'
