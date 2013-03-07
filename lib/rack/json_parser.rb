require 'multi_json'

module Rack
  # A middle ware to alwyas parse body as JSON.
  #
  # @example
  #  use Rack::Params::JSONParser
  #
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
