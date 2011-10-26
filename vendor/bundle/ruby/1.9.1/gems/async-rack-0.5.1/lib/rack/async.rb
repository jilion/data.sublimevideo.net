require 'rack'

module Rack
  fail 'Rack version mismatch' if release != '1.2'
  ASYNC_RESPONSE = [-1, {}, []].freeze

  module Async
    # Tools used to wrap sync middleware
    autoload :AutoloadHook, 'rack/async/autoload_hook'
    autoload :Original,     'rack/async/original'
    autoload :Wrapper,      'rack/async/wrapper'
  end

  extend Async::AutoloadHook

  # Wrapped middleware
  autoload :ConditionalGet, 'rack/async/conditional_get'
  autoload :Lint,           'rack/async/lint'

  # New middleware
  autoload :ReplaceableResponse,  'rack/replaceable_response'

  module Session
    extend Async::AutoloadHook
  end
end
