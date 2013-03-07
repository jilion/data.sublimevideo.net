source 'http://rubygems.org'
ruby '1.9.3'

gem 'goliath'
gem 'oj' # fast json

gem 'sidekiq'
gem 'redis', require: ['redis/connection/synchrony', 'redis']
gem 'hiredis'
gem 'moped'

# https://github.com/adamlwatson/goliath/blob/master/examples/newrelic_stats/newrelic_stats.rb
gem 'newrelic_rpm'
gem 'newrelic-redis'
gem 'airbrake'
gem 'librato-metrics'

group :test do
  gem 'em-http-request'
  gem 'rspec'
end

group :tools do
  # Guard
  gem 'ruby_gntp'
  gem 'rb-fsevent'
  gem 'rb-readline'
  gem 'guard-rspec'
end
