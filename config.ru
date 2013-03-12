#!/usr/bin/env ruby
$LOAD_PATH.unshift("#{Dir.pwd}/lib")

require "bundler"
Bundler.require

require './config'
require 'rack/status'
# require "rack/timeout"
# require 'rack/newrelic'
require 'rack/cors'
require 'rack/get_redirector'
require 'rack/json'
require 'application'

# Ensure the agent is started using Unicorn
# This is needed when using Unicorn and preload_app is not set to true.
# See http://support.newrelic.com/kb/troubleshooting/unicorn-no-data
# ::NewRelic::Agent.after_fork(force_reconnect: true) if defined? Unicorn

# use Airbrake::Rack
# use Rack::Timeout
# Rack::Timeout.timeout = 5  # this line is optional. if omitted, default is 15 seconds.
use Rack::Status
# use Rack::Newrelic
use Rack::GETRedirector
use Rack::Cors
use Rack::JSON

run Application.new
