module Rack
  class CORS
    def initialize(app)
      @app = app
    end

    def call(env)
      case env['REQUEST_METHOD']
      when 'OPTIONS'
        [200, {
          'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => 'POST',
          'Access-Control-Allow-Headers' => 'Content-Type',
          'Access-Control-Max-Age' => '1728000'
        }, []]
      when 'POST'
        status, headers, body = @app.call(env)
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Cache-Control'] = 'no-cache'
        [status, headers, body]
      else # GIF request
        @app.call(env)
      end
    end
  end
end
