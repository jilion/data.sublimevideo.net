source 'http://rubygems.org'
ruby '1.9.3'

gem 'puma', '2.0.0.b7'

gem 'rack'
gem 'rack-status'
gem 'rack-timeout', github: 'kch/rack-timeout', branch: 'debug'

gem 'yajl-ruby', require: 'yajl' # fast json

gem 'sidekiq'

# https://github.com/adamlwatson/goliath/blob/master/examples/newrelic_stats/newrelic_stats.rb
gem 'newrelic_rpm'
gem 'airbrake'
gem 'librato-metrics', require: 'librato/metrics'
gem 'rescue_me'

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'timecop'
  # Guard
  gem 'ruby_gntp'
  gem 'rb-fsevent'
  gem 'rb-readline'
  gem 'guard-rspec'
end
