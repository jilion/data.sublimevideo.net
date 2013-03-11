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
use Rack::Timeout
Rack::Timeout.timeout = 5  # this line is optional. if omitted, default is 15 seconds.
use Rack::Status
use Rack::Newrelic
use Airbrake::Rack
use Rack::GETRedirector       # add good headers for CORS
use Rack::Cors                # add good headers for CORS
use Rack::JSON

run Application.new
