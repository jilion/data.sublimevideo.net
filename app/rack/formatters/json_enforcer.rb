require 'multi_json'

module Rack
  module Formatters
    # A JSON formatter. Uses MultiJson so you can use the JSON
    # encoder that is right for your project.
    #
    # @example
    #   use Rack::Formatters::JSON
    class JSONEnforcer
      include Goliath::Rack::AsyncMiddleware

      def post_process(env, status, headers, body)
        body = [MultiJson.dump(body)]
        [status, headers, body]
      end
    end
  end
end
