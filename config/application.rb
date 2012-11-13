NewRelic::Agent.manual_start(env: Goliath.env.to_s)

Sidekiq.configure_client do |config|
  config.redis = { driver: 'synchrony' }
end
