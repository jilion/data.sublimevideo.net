require 'multi_json'

module Rack
  class Events
    def initialize(app)
      @app = app
    end

    def call(env)
      case env['REQUEST_METHOD']
      when 'POST' then _handle_post(env)
      when 'GET', 'HEAD' # GIF request
        env['data.events'] = _load(:query_string, env)
        @app.call(env)
      else
        @app.call(env)
      end
    end

    private

    def _handle_post(env)
      env['data.events'] = _load(:rack_input, env)
      if env['data.events'].nil? || env['data.events'].empty?
        [400, { 'Content-Type' => 'text/plain', 'Content-Length' => '11' }, ['Bad Request']]
      else
        status, headers, body = @app.call(env)
        [status, headers, [_dump_body(body, env)]]
      end
    end

    def _load(type, env)
      send("_load_#{type.to_s}", env)
    rescue
      []
    end

    def _load_query_string(env)
      case env['QUERY_STRING']
      when /[&?]d=([^&]*)/, /&(%5B[^&]*%5D)/ then MultiJson.load(URI.unescape($1))
      else []
      end
    end

    def _load_rack_input(env)
      body = env['rack.input'] && env['rack.input'].read
      case body
      when '', nil then []
      else MultiJson.load(body)
      end
    end

    def _dump_body(body, env)
      MultiJson.dump(body)
    end
  end
end
