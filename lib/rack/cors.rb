module Rack
  class Cors
    include Goliath::Rack::AsyncMiddleware

    def call(env, *args)
      if env['REQUEST_METHOD'] == 'OPTIONS'
        [200, {
          'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => 'POST',
          'Access-Control-Allow-Headers' => 'Content-Type',
          'Access-Control-Allow-Credentials' => 'true',
          'Access-Control-Max-Age' => '1728000'
        }, {}]
      else
        super(env, *args)
      end
    end

    def post_process(env, status, headers, body)
      headers ||= {}
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Cache-Control'] = 'no-cache'
      [status, headers, body]
    end

  end
end
