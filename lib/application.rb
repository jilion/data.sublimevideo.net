# require 'events_responder'

class Application
  def call(env)
    [200, {}, body(env)]
  end

  private

  def body(env)
  #   if site_token = extract_site_token(env)
  #     EventsResponder.new(site_token, env['params']).response
  #   else
  #     []
  #   end
  # rescue # => e
  #   # Airbrake.notify_or_ignore(e)
  #   []
    []
  end

  # def extract_site_token(env)
  #   matches = env['PATH_INFO'].match(%r{/([a-z0-9]{8}).json})
  #   matches && matches[1]
  # end
end
