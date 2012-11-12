#!/usr/bin/env ruby
require 'goliath'
require 'yajl'
require File.dirname(__FILE__) + '/app/rack/cors'
require File.dirname(__FILE__) + '/app/rack/json_parser'
require File.dirname(__FILE__) + '/app/rack/formatters/json_enforcer'


class Application < Goliath::API
  use Rack::Cors                       # Add good headers for CORS
  use Goliath::Rack::Params            # parse & merge query and body parameters
  use Rack::JSONParser         # parse & merge query and body parameters
  use Goliath::Rack::DefaultMimeType   # cleanup accepted media types
  use Goliath::Rack::Render            # auto-negotiate response format
  use Goliath::Rack::Heartbeat         # respond to /status with 200, OK (monitoring, etc)
  use Rack::Formatters::JSONEnforcer          # JSON output formatter

  def response(env)
    [200, {}, params]
  end
end
