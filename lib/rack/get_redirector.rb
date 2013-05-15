module Rack
  class GETRedirector
    def initialize(app)
      @app = app
    end

    def call(env)
      if _get_request_but_not_gif?(env)
        [301, { 'Location' => 'http://sublimevideo.net' }, ['Redirect to http://sublimevideo.net']]
      else
        @app.call(env)
      end
    end

    private

    def _get_request_but_not_gif?(env)
      env['REQUEST_METHOD'] == 'GET' && env['PATH_INFO'] != '/_.gif'
    end
  end
end
