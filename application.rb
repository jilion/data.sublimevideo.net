#!/usr/bin/env ruby
require 'goliath'
require 'yajl'
require File.dirname(__FILE__) + '/app/rack/cors'

class Application < Goliath::API
  use Rack::Cors                       # Add good headers for CORS
  use Goliath::Rack::Params            # parse & merge query and body parameters
  use Goliath::Rack::DefaultMimeType   # cleanup accepted media types
  use Goliath::Rack::Formatters::JSON  # JSON output formatter
  use Goliath::Rack::Render            # auto-negotiate response format
  use Goliath::Rack::Heartbeat         # respond to /status with 200, OK (monitoring, etc)

  def response(env)
    response_params = Yajl::Encoder.encode(params)
    [200, {}, response_params]
  end
end
