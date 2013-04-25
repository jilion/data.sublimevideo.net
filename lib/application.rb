require 'events_responder'
require 'rack/file'

class Application

  def call(env)
    response_body = handle_event(env)
    case env['REQUEST_METHOD']
    when 'POST'
      [200, {}, response_body]
    when 'GET' # GIF Request
      Rack::File.new('public', 'Cache-Control' => 'no-cache').call(env)
    end
  end

  private

  def handle_event(env)
    return [] unless env['site_token']
    req = Rack::Request.new(env)
    EventsResponder.new(env['site_token'], env['params'], req).response
  end
end
