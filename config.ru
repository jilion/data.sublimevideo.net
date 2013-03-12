#!/usr/bin/env ruby
$LOAD_PATH.unshift("#{Dir.pwd}/lib")

require "bundler"
Bundler.require

require './config'
require 'rack/status'
require 'rack/newrelic'
require 'rack/cors'
require 'rack/get_redirector'
require 'rack/json'
require 'application'

require "rack/timeout"
use Airbrake::Rack
use Rack::Timeout
Rack::Timeout.timeout = 5  # this line is optional. if omitted, default is 15 seconds.
use Rack::Status
use Rack::Newrelic
use Rack::GETRedirector
use Rack::Cors
use Rack::JSON

run Application.new
