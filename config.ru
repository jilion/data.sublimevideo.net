#!/usr/bin/env ruby
$LOAD_PATH.unshift("#{Dir.pwd}/lib")

require "bundler"
Bundler.require

require './config'
require 'rack/cors'
require 'rack/get_redirector'
require 'rack/events'
require 'rack/newrelic'
require 'rack/site_token'
require 'rack/status'
require 'application'

use Rack::Status
use Honeybadger::Rack
use Rack::Newrelic
use Librato::Rack
use Rack::GETRedirector
use Rack::CORS
use Rack::SiteToken
use Rack::Events

run Application.new
