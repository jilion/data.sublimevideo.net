Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
end

Sidekiq.configure_client do |config|
  config.redis = { size: 5 }
end

Librato::Metrics.authenticate ENV['LIBRATO_METRICS_USER'], ENV['LIBRATO_METRICS_TOKEN']
$metrics_queue = Librato::Metrics::Queue.new(autosubmit_interval: 60)
