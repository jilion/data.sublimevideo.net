module Rack
  class GETRedirector
    include Goliath::Rack::AsyncMiddleware

    def call(env, *args)
      if env['REQUEST_METHOD'] == 'GET'
        [301, { 'Location' => 'http://sublimevideo.net' }, "Redirect to http://sublimevideo.net"]
      else
        super(env, *args)
      end
    end

  end
end
