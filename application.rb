#!/usr/bin/env ruby
require 'goliath'
require 'yajl'
require File.dirname(__FILE__) + '/app/rack/cors'
require File.dirname(__FILE__) + '/app/rack/json_parser'
require File.dirname(__FILE__) + '/app/rack/formatters/json_enforcer'


class Application < Goliath::API
  use Rack::Cors                       # add good headers for CORS
  use Goliath::Rack::Params            # parse & merge query and body parameters
  use Rack::JSONParser                 # always parse & merge body parameters as JSON
  use Goliath::Rack::DefaultMimeType   # cleanup accepted media types
  use Goliath::Rack::Render            # auto-negotiate response format
  use Goliath::Rack::Heartbeat         # respond to /status with 200, OK (monitoring, etc)
  use Rack::Formatters::JSONEnforcer   # always ouptut JSON

  def response(env)
    [200, {}, params]
  end
end
