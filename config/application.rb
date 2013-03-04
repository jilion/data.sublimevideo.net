NewRelic::Agent.manual_start(env: Goliath.env.to_s)

Sidekiq.configure_client do |config|
  config.redis = { driver: 'synchrony' }
end

require 'moped'
config['moped'] = EM::Synchrony::ConnectionPool.new(size: 10) do
  mongo_uri = URI.parse(ENV['MONGOHQ_URI'] || 'mongodb://127.0.0.1/sv-data2')
  session = Moped::Session.new(
    [[mongo_uri.host, mongo_uri.port].compact.join(':')],
    database: mongo_uri.path.gsub(/^\//, ''))
  session.login(mongo_uri.user, mongo_uri.password) if mongo_uri.user
  session
end

require 'airbrake'
Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
end
