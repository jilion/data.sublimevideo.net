require 'new_relic/agent/instrumentation/rack'

module DataSublimeVideo

  class NewRelic < AsyncRack::CommonLogger
    def async_callback(result)
      super result
    end

    def call(env)
      super
    end

    include ::NewRelic::Agent::Instrumentation::Rack
  end

end
