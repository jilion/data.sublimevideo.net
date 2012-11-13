source 'http://rubygems.org'
ruby '1.9.3'

gem 'goliath'
gem 'yajl-ruby', require: 'yajl' # fast json

gem 'sidekiq'
gem 'redis', '~> 3.0.1', require: ['redis/connection/synchrony', 'redis']
gem 'hiredis', '~> 0.4.5'

# https://github.com/adamlwatson/goliath/blob/master/examples/newrelic_stats/newrelic_stats.rb
# gem 'newrelic_rpm'
# gem 'rpm_contrib'

group :test do
  gem 'em-http-request'
  gem 'rspec'
end

group :tools do
  gem 'powder'

  # Guard
  gem 'ruby_gntp'
  gem 'rb-fsevent'
  gem 'rb-readline'
  gem 'guard-rspec'
end
