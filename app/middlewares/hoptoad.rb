module Goliath
  module Rack
    class Hoptoad
      include Goliath::Constants

      def initialize(app)
        @app = app
      end

      def call(env)
        response = @app.call(env)

        if env[RACK_EXCEPTION]
          HoptoadNotifier.notify(env[RACK_EXCEPTION])
        end
        response
      rescue Exception => e
        HoptoadNotifier.notify(e)
      end

    end
  end
end