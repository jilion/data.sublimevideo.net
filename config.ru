#!/usr/bin/env ruby
require "bundler"
Bundler.require

$: << File.dirname(__FILE__) + '/config'
require 'application'

$: << File.dirname(__FILE__) + '/lib'
require 'rack/status'
require 'new_relic/agent/instrumentation/rack'
require 'rack/cors'
require 'rack/get_redirector'
require 'rack/json_parser'
require 'rack/json_formatter'
require 'events_responder'

class Application
  def call(env)
    site_token = extract_site_token(env)
    response = if site_token
      EventsResponder.new(env, site_token, params).response
    else
      []
    end
    [200, {}, response]
  end

  include NewRelic::Agent::Instrumentation::Rack

  private

  def extract_site_token(env)
    matches = env['REQUEST_PATH'].match(%r{/([a-z0-9]{8}).json})
    matches && matches[1]
  end
end

use Rack::Status
use Airbrake::Rack
use Rack::GETRedirector       # add good headers for CORS
use Rack::Cors                # add good headers for CORS
use Rack::JSONParser          # always parse & merge body parameters as JSON
use Rack::JSONFormatter       # always ouptut JSON

run Application.new
