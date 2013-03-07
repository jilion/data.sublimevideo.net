require 'multi_json'

module Rack
  class JSONParser
    def initialize(app)
      @app = app
    end

    def call(env)
      env['params'] = {}
      if env && env['rack.input']
        body = env['rack.input'].read
        env['rack.input'].rewind
        env['params'] = MultiJson.load(body) || {}
      end
      @app.call(env)
    end
  end
end
