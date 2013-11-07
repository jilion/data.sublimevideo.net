require 'events_responder'
require 'rack/file'

class Application

  def call(env)
    if env['data.site_token']
      body = EventsResponder.new(env).response
      if _gif_request?(env)
        Rack::File.new('public', 'Cache-Control' => 'no-cache').call(env)
      else # ajax
        [200, {}, body]
      end
    else
      [404, {'Content-Type' => 'text/html', 'Content-Length' => '9'}, ['Not Found']]
    end
  end

  private

  def _gif_request?(env)
    env['PATH_INFO'] == '/_.gif'
  end
end
