require 'events_responder'
require 'rack/file'

class Application

  def call(env)
    if env['data.site_token']
      body = EventsResponder.new(env).response
      _gif_request?(env) ? _gif_response(env) : [200, {'Content-Type' => 'text/plain'}, body]
    else
      _gif_request?(env) ? _gif_response(env) : _404_response
    end
  end

  private

  def _gif_request?(env)
    env['PATH_INFO'] == '/_.gif'
  end

  def _gif_response(env)
    Rack::File.new('public', 'Cache-Control' => 'no-cache').call(env)
  end

  def _404_response
    [404, {'Content-Type' => 'text/plain', 'Content-Length' => '9'}, ['Not Found']]
  end
end
