module Rack
  class SiteToken
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)
      env['site_token'] = _extract_site_token(req)
      @app.call(env)
    end

    private

    def _extract_site_token(req)
      case req.path_info
      when %r{/([a-z0-9]{8}).json} then $1
      when '/_.gif' then req.params['s']
      else; nil
      end
    end
  end
end
