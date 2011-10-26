require 'rack/lint'

module Rack
  module Async
    class Lint < Original::Lint
      def check_status(status)                  super unless status.to_i < 0  end
      def check_content_type(status, headers)   super unless status.to_i < 0  end
      def check_content_length(status, headers) super unless status.to_i < 0  end

      def _call(env)
        status, *rest = catch(:async) { super } || ASYNC_RESPONSE
        assert "async response detected without the handler supporting async.callback" do
          status.to_i < 0 and not env.include?('async.callback')
        end
        [status, *rest]
      end
    end
  end

  const_remove :Lint
  Lint = Async::Lint
end
