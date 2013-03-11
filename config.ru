#!/usr/bin/env ruby
$LOAD_PATH.unshift("#{Dir.pwd}/lib")

require "bundler"
Bundler.require

require './config'
require 'rack/status'
require 'rack/newrelic'
require 'rack/cors'
require 'rack/get_redirector'
require 'rack/json_parser'
require 'rack/json_formatter'
require 'application'

use Rack::Status
use Rack::Newrelic
use Airbrake::Rack
use Rack::GETRedirector       # add good headers for CORS
use Rack::Cors                # add good headers for CORS
use Rack::JSONParser          # always parse & merge body parameters as JSON
use Rack::JSONFormatter       # always ouptut JSON

run Application.new
