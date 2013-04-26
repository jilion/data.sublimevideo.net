require 'events_responder'
require 'rack/file'

class Application

  def call(env)
    response_body = handle_event(env)
    if gif_request?(env)
      Rack::File.new('public', 'Cache-Control' => 'no-cache').call(env)
    else
      [200, {}, response_body]
    end
  end

  private

  def gif_request?(env)
    env['REQUEST_METHOD'] == 'GET'
  end

  def handle_event(env)
    return [] unless env['site_token']
    req = Rack::Request.new(env)
    EventsResponder.new(env['site_token'], env['params'], req).response
  end
end
