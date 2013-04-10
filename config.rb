Honeybadger.configure do |config|
  config.api_key = '7586a6c1'
end

Librato::Metrics.authenticate ENV['LIBRATO_METRICS_USER'], ENV['LIBRATO_METRICS_TOKEN']
$metrics_queue = Librato::Metrics::Queue.new(autosubmit_interval: 300)
