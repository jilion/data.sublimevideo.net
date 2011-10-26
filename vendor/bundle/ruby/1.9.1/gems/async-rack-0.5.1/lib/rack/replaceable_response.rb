module Rack
  ##
  # Middleware that allows setting a predefined response for a request.
  # If response is set, it will be returned instead of handing env on to
  # the next middleware/endpoint. Response is stored in env, so it will be
  # eaten by the GC as soon as possible.
  #
  # @example
  #   class Wrapper < Wrapped
  #     def call(env)
  #       @app.response_for(env, some_response) if some_condition
  #       super
  #     end
  #   end
  #
  #   use Wrapper
  #   use ReplaceableResponse
  #   run SomeApp
  class ReplaceableResponse
    def initialize(app)                 @app = app                                      end
    def response_for(env, result = nil) (env['cached.responses'] ||= {})[self] = result end
    def call(env)                       response_for(env) or @app.call(env)             end
    alias set_response_for response_for
  end
end
