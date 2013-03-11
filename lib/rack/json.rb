require 'multi_json'

module Rack
  class JSON
    def initialize(app)
      @app = app
    end

    def call(env)
      parse_json(env)
      status, headers, body = @app.call(env)
      [status, headers, MultiJson.dump(body)]
    end

    private

    def parse_json(env)
      env['params'] = {}
      if env && env['rack.input']
        body = env['rack.input'].read
        env['rack.input'].rewind
        env['params'] = MultiJson.load(body) || {}
      end
    end
  end
end
