module Rack
  module Async
    module AutoloadHook
      ##
      # Hooks into Rack.autoload to allow replacing already defined autoload
      # paths with the paths to the async counterparts but avoids accidentally
      # overwriting them with the old paths, for instance if Rack::Reloader is
      # used.
      #
      # If the middleware is already loaded, +require+ the counterpart.
      def autoload(const_name, path)
        if const_defined?(const_name) and not autoload?(const_name)
          require path
        elsif autoload?(const_name) !~ /^rack\/async/
          @autoloaded = false
          super
        end
      end

      ##
      # Module#autoload is not thread-safe.
      # Use Rack.autoload! to preload all middleware in order to avoid race conditions.
      def autoload!
        return if @autoloaded
        @autoloaded = true
        constants.each do |const_name|
          const = const_get(const_name)
          const.autoload! if const.respond_to? :autoload!
        end
      end
    end
  end
end