source 'http://rubygems.org'
source 'https://gems.gemfury.com/8dezqz7z7HWea9vtaFwg/' # thibaud@jilion.com account

gem 'rake', '0.9.2'

gem 'cramp'

# Async webserver for running a cramp application
gem 'thin'

# Rack based routing
gem 'http_router'

# Collection of async-proof rack middlewares - https://github.com/rkh/async-rack.git
gem 'async-rack'

# For stats parsing
gem 'useragent', git: 'git://github.com/jilion/useragent.git' # needed for stat_request_parser
gem 'stat_request_parser',   '~> 1.0.0' # hosted on gemfury

gem 'settingslogic'
gem 'pusher'
gem 'em-http-request'

# For Mongoid.
gem 'bson_ext'
gem 'mongoid'
gem 'em-mongo'

gem 'newrelic_rpm'
gem 'rpm_contrib'

platforms :mri_19 do
  # Using Fibers + async callbacks to emulate synchronous programming
  gem 'em-synchrony', '~> 1.0.0'
end

# Generic interface to multiple Ruby template engines - https://github.com/rtomayko/tilt
# gem 'tilt'

group :development do
  gem 'heroku'
  gem 'bundler'
  gem 'foreman'
  # Development gems
  # gem 'ruby-debug19'
end

group :test do
  gem 'rb-fsevent', '~> 0.9.0.pre3'
  gem 'growl_notify'
  gem 'guard-rspec'
  gem 'rspec'
  gem 'rspec-cramp', require: 'rspec/cramp'
end
