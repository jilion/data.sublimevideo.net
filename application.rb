#!/usr/bin/env ruby
require "bundler"
Bundler.require

$: << File.dirname(__FILE__) + '/lib'
require 'rack/cors'
require 'rack/get_redirector'
require 'rack/json_parser'
require 'rack/json_formatter'
require 'events_responder'

NewRelic::Agent.manual_start(env: Goliath.env.to_s)

class Application < Goliath::API
  use Goliath::Rack::Heartbeat  # respond to /status with 200, OK (monitoring, etc)
  use Airbrake::Rack
  use Rack::GETRedirector       # add good headers for CORS
  use Rack::Cors                # add good headers for CORS
  use Rack::JSONParser          # always parse & merge body parameters as JSON
  use Rack::JSONFormatter       # always ouptut JSON

  def response(env)
    raise "test airbrake"
    site_token = extract_site_token(env)
    response = if site_token
      EventsResponder.new(env, site_token, params).response
    else
      []
    end
    [200, {}, response]
  end

  private

  def extract_site_token(env)
    matches = env['REQUEST_PATH'].match(%r{/([a-z0-9]{8}).json})
    matches && matches[1]
  end
end
