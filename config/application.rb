require 'sidekiq'
Sidekiq.configure_client do |config|
  config.redis = { size: 20 }
end

require 'mongo'
include Mongo
$mongo = MongoClient.new(pool_size: 20, pool_timeout: 5).db['sv-data']

require 'librato/metrics'
Librato::Metrics.authenticate ENV['LIBRATO_METRICS_USER'], ENV['LIBRATO_METRICS_TOKEN']
$metrics_queue = Librato::Metrics::Queue.new(autosubmit_interval: 5)

require 'airbrake'
Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
end
