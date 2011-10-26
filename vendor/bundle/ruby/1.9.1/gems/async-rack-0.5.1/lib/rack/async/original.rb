module Rack
  module Session; end
  module Async
    ##
    # This module is used as a bucket to keep a reference
    # to old middleware in case it was replaced by a new implementation.
    #
    # Rack::Foo might get replaced by Rack::Async::Foo. The old Rack::Foo
    # is still accessable as Rack::Original::Foo, if Rack::Async::Foo is
    # subclassing it (recommended).
    module Original
      module Store
        attr_accessor :base
        def const_missing(name)
          const_set name, base.const_get(name)
        end
      end

      extend Store
      self.base = ::Rack

      module Session
        extend Store
        self.base = ::Rack::Session
      end
    end
  end
end
