require 'multi_json'

module Rack
  class Events
    def initialize(app)
      @app = app
    end

    def call(env)
      case env['REQUEST_METHOD']
      when 'POST'
        env['data.events'] = _load(:rack_input, env)
        status, headers, body = @app.call(env)
        [status, headers, [_dump_body(body, env)]]
      when 'GET', 'HEAD' # GIF request
        env['data.events'] = _load(:query_string, env)
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
      when /[&?]d=(.*)/ then MultiJson.load($1)
      when /&({.*})/ then [MultiJson.load($1)] # Bugged d params
      when /&([.*])/ then MultiJson.load($1) # Bugged d params
      else
        Honeybadger.notify(error_class: 'Special Error', error_message: 'Special Error: query string is invalid', rack_env: env)
        []
      end
    end

    def _load_rack_input(env)
      body = env['rack.input'] && env['rack.input'].read
      case body
      when '', nil then []
      else MultiJson.load(body)
      end
    rescue => ex
      Honeybadger.notify_or_ignore(ex, rack_env: env, parameters: { body: body })
      []
    end

    def _dump_body(body, env)
      MultiJson.dump(body)
    rescue => ex
      Honeybadger.notify_or_ignore(ex, rack_env: env)
      '[]'
    end
  end
end
