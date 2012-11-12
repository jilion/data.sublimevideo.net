#!/usr/bin/env ruby
require 'goliath'
require 'yajl'
require 'rack/cors'

class Application < Goliath::API
  use Goliath::Rack::Params                 # parse & merge query and body parameters
  use Goliath::Rack::DefaultMimeType        # cleanup accepted media types
  use Goliath::Rack::Formatters::JSON       # JSON output formatter
  use Goliath::Rack::Render                 # auto-negotiate response format
  use Goliath::Rack::Heartbeat              # respond to /status with 200, OK (monitoring, etc)
  use Rack::Cors do
    allow do
      origins '*'
    end
  end

  def response(env)
    body = Yajl::Encoder.encode(status: 'ok')
    [200, {}, body]
  end
end
