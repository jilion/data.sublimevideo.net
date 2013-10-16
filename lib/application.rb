require 'events_responder'
require 'rack/file'

class Application

  def call(env)
    body = _handle_event(env)
    if _gif_request?(env)
      Librato.increment 'data.request_type', source: 'gif'
      Rack::File.new('public', 'Cache-Control' => 'no-cache').call(env)
    else
      Librato.increment 'data.request_type', source: 'ajax'
      [200, {}, body]
    end
  end

  private

  def _gif_request?(env)
    env['REQUEST_METHOD'] == 'GET'
  end

  def _handle_event(env)
    if env['site_token']
      req = Rack::Request.new(env)
      EventsResponder.new(env['site_token'], env['params'], req).response
    else
      Honeybadger.notify(error_class: 'Special Error', error_message: 'Special Error: site_token is missing', parameters: env)
      []
    end
  end
end
