# Sidekiq.configure_client do |config|
#   config.redis = { size: 5}
# end

require 'moped'
mongo_uri = URI.parse(ENV['MONGOHQ_URI'] || 'mongodb://127.0.0.1/sv-data2')
$moped = Moped::Session.new(
  [[mongo_uri.host, mongo_uri.port].compact.join(':')],
  database: mongo_uri.path.gsub(/^\//, ''))
$moped.login(mongo_uri.user, mongo_uri.password) if mongo_uri.user

require 'librato/metrics'
Librato::Metrics.authenticate ENV['LIBRATO_METRICS_USER'], ENV['LIBRATO_METRICS_TOKEN']
$metrics_queue = Librato::Metrics::Queue.new(autosubmit_interval: 5)

require 'airbrake'
Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
end
