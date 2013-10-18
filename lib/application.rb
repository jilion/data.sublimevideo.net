require 'events_responder'
require 'rack/file'

class Application

  def call(env)
    if env['data.site_token']
      body = EventsResponder.new(env).response
      if _gif_request?(env)
        Librato.increment 'data.request_type', source: 'gif'
        Rack::File.new('public', 'Cache-Control' => 'no-cache').call(env)
      else # ajax
        Librato.increment 'data.request_type', source: 'ajax'
        [200, {}, body]
      end
    else
      Librato.increment 'data.request_type', source: '404'
      [404, {'Content-Type' => 'text/html', 'Content-Length' => '9'}, ['Not Found']]
    end
  end

  private

  def _gif_request?(env)
    env['PATH_INFO'] == '/_.gif'
  end

  def _handle_event(env)
    req = Rack::Request.new(env)

  end
end
