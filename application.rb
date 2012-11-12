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
    case env['REQUEST_METHOD']
    when "OPTIONS"
      [200, {
        'Access-Control-Allow-Origin' => '*',
        'Access-Control-Allow-Methods' => 'POST',
        'Access-Control-Allow-Headers' => 'Content-Type',
        'Access-Control-Allow-Credentials' => true,
        'Access-Control-Max-Age' => 60 # 1728000
      }, {}]
    else
      response_params = Yajl::Encoder.encode(params)
      [200, { "Access-Control-Allow-Origin" => '*' }, response_params]
    end
  end
end
