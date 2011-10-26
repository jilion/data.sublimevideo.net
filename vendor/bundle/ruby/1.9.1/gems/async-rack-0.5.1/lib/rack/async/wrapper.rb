module Rack
  module Async
    module Wrapper
      def initialize(app, *args, &block)
        super(CachedResponse.new(app), *args, &block)
      end

      def call(env)
        return super unless callback = env['async.callback']
        env['async.callback'] = proc do |result|
          app.set_response_for(env, result)
          async_call(env)
        end
        catch(:async) { super } || ASYNC_RESPONSE
      end

      def async_call(env)
        call(env)
      end
    end
  end
end
