#!/usr/bin/env ruby
require "bundler"
Bundler.require

$: << File.dirname(__FILE__) + '/config'
require 'application'

$: << File.dirname(__FILE__) + '/lib'
require 'rack/status'
require 'rack/newrelic'
require 'rack/cors'
require 'rack/get_redirector'
require 'rack/json_parser'
require 'rack/json_formatter'
require 'events_responder'

class Application
  def call(env)
    [200, {}, body(env)]
  end

  private

  def body(env)
    if site_token = extract_site_token(env)
      EventsResponder.new(site_token, env['params']).response
    else
      []
    end
  end

  def extract_site_token(env)
    matches = env['PATH_INFO'].match(%r{/([a-z0-9]{8}).json})
    matches && matches[1]
  end
end

use Rack::Status
use Rack::Newrelic
use Airbrake::Rack
use Rack::GETRedirector       # add good headers for CORS
use Rack::Cors                # add good headers for CORS
use Rack::JSONParser          # always parse & merge body parameters as JSON
use Rack::JSONFormatter       # always ouptut JSON

run Application.new
