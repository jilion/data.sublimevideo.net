#!/usr/bin/env ruby
require 'goliath'
require 'yajl'
# require 'rack/cors'

class Application < Goliath::API
  # use Rack::Cors do
  #   allow do
  #     origins '*'
  #     resource '/*', headers: :any, methods: :get
  #   end
  # end
  use Goliath::Rack::Params                 # parse & merge query and body parameters
  use Goliath::Rack::DefaultMimeType        # cleanup accepted media types
  use Goliath::Rack::Formatters::JSON       # JSON output formatter
  use Goliath::Rack::Render                 # auto-negotiate response format
  use Goliath::Rack::Heartbeat              # respond to /status with 200, OK (monitoring, etc)

  def response(env)
    case env['REQUEST_METHOD']
    when "OPTIONS"
      [200, { "Access-Control-Allow-Origin" => '*', 'Access-Control-Allow-Headers' => 'Content-Type' }, {}]
    else
      response_params = Yajl::Encoder.encode(params)
      [200, {}, response_params]
    end
  end
end
