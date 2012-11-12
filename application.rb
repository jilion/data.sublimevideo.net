#!/usr/bin/env ruby
require 'goliath'
require 'yajl'

class Application < Goliath::API
  use Goliath::Rack::Params                 # parse & merge query and body parameters
  use Goliath::Rack::DefaultMimeType        # cleanup accepted media types
  use Goliath::Rack::Formatters::JSON       # JSON output formatter
  use Goliath::Rack::Render                 # auto-negotiate response format
  use Goliath::Rack::Heartbeat              # respond to /status with 200, OK (monitoring, etc)

  def response(env)
    [200, {}, "echo:'#{params['echo']}'"]
  end
end
