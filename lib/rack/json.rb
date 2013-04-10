require 'multi_json'

module Rack
  class JSON
    def initialize(app)
      @app = app
    end

    def call(env)
      env['params'] = load_input(env) || {}
      status, headers, body = @app.call(env)
      [status, headers, [dump_output(body)]]
    end

    private

    def load_input(env)
      if env && env['rack.input']
        body = env['rack.input'].read
        env['rack.input'].rewind
        MultiJson.load(body)
      end
    rescue => ex
      notify_honeybadger(ex)
      []
    end

    def dump_output(body)
      MultiJson.dump(body)
    rescue => ex
      notify_honeybadger(ex)
      "[]"
    end
  end
end
