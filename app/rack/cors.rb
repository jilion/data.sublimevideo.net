module Rack
  class Cors
    include Goliath::Rack::AsyncMiddleware

    def call(env, *args)
      if options_resquest?(env)
        [200, {
          'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => 'POST',
          'Access-Control-Allow-Headers' => 'Content-Type',
          'Access-Control-Allow-Credentials' => 'true',
          'Access-Control-Max-Age' => '5'
        }, {}]
      else
        super(env, *args)
      end
    end

    def post_process(env, status, headers, body)
      headers['Access-Control-Allow-Origin'] = '*'
      [status, headers, body]
    end

    def options_resquest?(env)
      env['REQUEST_METHOD'] == 'OPTIONS'
    end
  end
end
