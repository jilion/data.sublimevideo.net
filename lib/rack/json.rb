require 'multi_json'

module Rack
  class JSON
    def initialize(app)
      @app = app
    end

    def call(env)
      env['params'] = parse_input(env) || {}
      status, headers, body = @app.call(env)
      [status, headers, MultiJson.dump(body)]
    end

    private

    def parse_input(env)
      if env && env['rack.input']
        body = env['rack.input'].read
        env['rack.input'].rewind
        MultiJson.load(body)
      end
    end
  end
end
