require 'multi_json'

module Rack
  # A middle ware to alwyas parse body as JSON.
  #
  # @example
  #  use Rack::Params::JSONParser
  #
  # module Params
    class JSONParser
      include Goliath::Rack::AsyncMiddleware

      def call(env)
        if env['rack.input']
          body = env['rack.input'].read
          env['rack.input'].rewind
          env['params'].merge!(MultiJson.load(body))
        end
      ensure
        @app.call(env)
      end
    end
  # end
end
