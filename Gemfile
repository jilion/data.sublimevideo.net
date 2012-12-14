source 'http://rubygems.org'
source 'https://gems.gemfury.com/8dezqz7z7HWea9vtaFwg/' # thibaud@jilion.com account

ruby '1.9.3'

gem 'rake'

gem 'cramp', git: 'git://github.com/wtn/cramp.git', branch: 'rails_3.1-3.2'

# Async webserver for running a cramp application
gem 'thin'

# Rack based routing
gem 'http_router'

# Collection of async-proof rack middlewares - https://github.com/rkh/async-rack.git
gem 'async-rack'

# For stats parsing
gem 'useragent', git: 'git://github.com/jilion/useragent.git' # needed for stat_request_parser
gem 'stat_request_parser', '~> 1.1.0' # hosted on gemfury

gem 'settingslogic'
gem 'pusher'
gem 'em-http-request'

# For Mongoid.
gem 'bson_ext'
gem 'mongoid'
gem 'em-mongo'

gem 'require_all'

gem 'newrelic_rpm'
gem 'rpm_contrib'

# Using Fibers + async callbacks to emulate synchronous programming
gem 'em-synchrony', '~> 1.0.0'

# For Redis
gem 'hiredis', '~> 0.4.5'
gem 'redis',   '~> 2.2.2', require: ['redis/connection/synchrony', 'redis']

# Generic interface to multiple Ruby template engines - https://github.com/rtomayko/tilt
# gem 'tilt'

group :test do
  gem 'rspec'
  gem 'rspec-cramp', require: 'rspec/cramp'
end

group :tools do
  gem 'heroku'
  gem 'foreman'
  gem 'powder'
  gem 'pry'

  # Guard
  gem 'growl'
  platforms :ruby do
    gem 'rb-readline'
  end

  gem 'guard-rspec'
end
