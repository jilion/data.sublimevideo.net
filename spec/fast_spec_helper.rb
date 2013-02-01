$LOAD_PATH.unshift("#{Dir.pwd}/lib") unless $LOAD_PATH.include?("#{Dir.pwd}/lib")

require 'bundler/setup'
require_relative 'config/rspec'
