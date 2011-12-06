require 'new_relic/agent/instrumentation/rack'

module DataSublimeVideo

  class NewRelic
    include ::AsyncRack::AsyncCallback::SimpleWrapper

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    end

    include ::NewRelic::Agent::Instrumentation::Rack
  end

end
