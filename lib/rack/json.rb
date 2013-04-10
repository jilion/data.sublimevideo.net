require 'multi_json'

module Rack
  class JSON
    def initialize(app)
      @app = app
    end

    def call(env)
      env['params'] = load_input(env) || {}
      status, headers, body = @app.call(env)
      [status, headers, [dump_output(body, env)]]
    end

    private

    def load_input(env)
      if env && env['rack.input']
        body = env['rack.input'].read
        env['rack.input'].rewind
        body == '' ? [] : MultiJson.load(body)
      end
    rescue => ex
      Honeybadger.notify_or_ignore(ex, rack_env: env)
      []
    end

    def dump_output(body, env)
      MultiJson.dump(body)
    rescue => ex
      Honeybadger.notify_or_ignore(ex, rack_env: env)
      "[]"
    end
  end
end
