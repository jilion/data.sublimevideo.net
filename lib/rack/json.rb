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
    rescue => e
      Airbrake.notify_or_ignore(e)
      []
    end

    def dump_output(body)
      MultiJson.dump(body)
    rescue => e
      Airbrake.notify_or_ignore(e)
      "[]"
    end
  end
end
