require 'multi_json'

module Rack
  class JSONFormatter
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      body = [MultiJson.dump(body)]
      [status, headers, body]
    end
  end
end
