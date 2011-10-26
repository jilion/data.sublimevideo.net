require 'rack/conditionalget'

module Rack
  module Async
    module ConditionalGet < Original::ConditionalGet
      include Wrapper
    end
  end

  const_remove :ConditionalGet
  ConditionalGet = Async::ConditionalGet
end
