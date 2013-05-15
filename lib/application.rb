require 'events_responder'
require 'rack/file'

class Application

  def call(env)
    body = _handle_event(env)
    if _gif_request?(env)
      Rack::File.new('public', 'Cache-Control' => 'no-cache').call(env)
    else
      [200, {}, body]
    end
  end

  private

  def _gif_request?(env)
    env['REQUEST_METHOD'] == 'GET'
  end

  def _handle_event(env)
    return [] unless env['site_token']
    req = Rack::Request.new(env)
    EventsResponder.new(env['site_token'], env['params'], req).response
  end
end
