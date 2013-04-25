require 'multi_json'

module Rack
  class JSON
    def initialize(app)
      @app = app
    end

    def call(env)
      env['params'] = load_json_params(env)
      if env['REQUEST_METHOD'] == 'POST'
        status, headers, body = @app.call(env)
        [status, headers, [dump_body(body, env)]]
      else # GIF request
        @app.call(env)
      end
    end

    private

    def load_json_params(env)
      send("load_#{env['REQUEST_METHOD']}_json_params", env)
    rescue => ex
      Honeybadger.notify_or_ignore(ex, rack_env: env)
    ensure
      []
    end

    def load_GET_json_params(env)
      case URI.unescape(env['QUERY_STRING'])
      when /d=(.*)/ then MultiJson.load($1)
      else; []
      end
    end

    def load_POST_json_params(env)
      body = env['rack.input'] && env['rack.input'].read
      case body
      when '', nil then []
      else MultiJson.load(body)
      end
    end

    def dump_body(body, env)
      MultiJson.dump(body)
    rescue => ex
      Honeybadger.notify_or_ignore(ex, rack_env: env)
      '[]'
    end
  end
end
