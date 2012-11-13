Sidekiq.configure_client do |config|
  config.redis = { driver: 'synchrony' }
end
