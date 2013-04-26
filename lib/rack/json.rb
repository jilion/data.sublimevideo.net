require 'multi_json'

module Rack
  class JSON
    def initialize(app)
      @app = app
    end

    def call(env)
      case env['REQUEST_METHOD']
      when 'POST'
        env['params'] = load(:rack_input, env)
        status, headers, body = @app.call(env)
        [status, headers, [dump_body(body, env)]]
      when 'GET' # GIF request
        env['params'] = load(:query_string, env)
        @app.call(env)
      else
        @app.call(env)
      end
    end

    private

    def load(type, env)
      send("load_#{type.to_s}", env)
    rescue => ex
      Honeybadger.notify_or_ignore(ex, rack_env: env)
      []
    end

    def load_query_string(env)
      case URI.unescape(env['QUERY_STRING'])
      when /d=(.*)/ then MultiJson.load($1)
      else []
      end
    end

    def load_rack_input(env)
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
