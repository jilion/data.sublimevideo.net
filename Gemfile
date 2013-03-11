source 'http://rubygems.org'
ruby '1.9.3'

gem 'rack'
gem 'rack-status'
gem 'puma'

gem 'yajl-ruby', require: 'yajl' # fast json

gem 'sidekiq'

# https://github.com/adamlwatson/goliath/blob/master/examples/newrelic_stats/newrelic_stats.rb
gem 'newrelic_rpm'
gem 'newrelic-redis'
gem 'airbrake'
gem 'librato-metrics'

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'timecop'
end

group :tools do
  # Guard
  gem 'ruby_gntp'
  gem 'rb-fsevent'
  gem 'rb-readline'
  gem 'guard-rspec'
end
