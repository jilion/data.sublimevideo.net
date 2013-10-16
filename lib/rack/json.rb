require 'multi_json'

module Rack
  class JSON
    def initialize(app)
      @app = app
    end

    def call(env)
      case env['REQUEST_METHOD']
      when 'POST'
        env['params'] = _load(:rack_input, env)
        status, headers, body = @app.call(env)
        [status, headers, [_dump_body(body, env)]]
      when 'GET' # GIF request
        env['params'] = _load(:query_string, env)
        @app.call(env)
      else
        @app.call(env)
      end
    end

    private

    def _load(type, env)
      send("_load_#{type.to_s}", env)
    rescue => ex
      Honeybadger.notify_or_ignore(ex, rack_env: env)
      []
    end

    def _load_query_string(env)
      case URI.unescape(env['QUERY_STRING'])
      when /d=(.*)/ then MultiJson.load($1)
      else
        Honeybadger.notify(error_class: 'Special Error', error_message: 'Special Error: query string is invalid', parameters: env)
        []
      end
    end

    def _load_rack_input(env)
      body = env['rack.input'] && env['rack.input'].read
      case body
      when '', nil
        Honeybadger.notify(error_class: 'Special Error', error_message: 'Special Error: rack input is invalid', parameters: env)
        []
      else MultiJson.load(body)
      end
    end

    def _dump_body(body, env)
      MultiJson.dump(body)
    rescue => ex
      Honeybadger.notify_or_ignore(ex, rack_env: env)
      '[]'
    end
  end
end
