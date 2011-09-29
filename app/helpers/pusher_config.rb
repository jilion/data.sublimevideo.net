class PusherConfig < Settingslogic
  source "#{DataSublimeVideo::Application.root}/config/pusher.yml"
  namespace DataSublimeVideo::Application.env
end