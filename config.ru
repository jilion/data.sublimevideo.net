require './application'

DataSublimeVideo::Application.initialize!

# Middlewares
case DataSublimeVideo::Application.env
when 'development'
  use AsyncRack::CommonLogger
  # Enable code reloading on every request
  use Rack::Reloader, 0
  # Serve assets from /public
  use Rack::Static, :urls => ["/javascripts"], :root => DataSublimeVideo::Application.root(:public)
when 'production'
  require './newrelic'
  use DataSublimeVideo::NewRelic
end

run DataSublimeVideo::Application.routes
