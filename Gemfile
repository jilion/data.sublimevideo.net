source :rubygems

gem 'rake'

gem 'cramp'

# Async webserver for running a cramp application
gem 'thin'

# Rack based routing
gem 'http_router'

# Collection of async-proof rack middlewares - https://github.com/rkh/async-rack.git
gem 'async-rack'

# For stats parsing
gem 'useragent', git: 'git://github.com/Jilion/useragent.git'
gem 'stat_request_parser', git: 'git@jime1.epfl.ch:sv_stats_request_parser.git'

gem 'settingslogic'
gem 'pusher'
gem 'em-http-request'

# For Mongoid.
gem 'bson_ext'
gem 'mongoid', '~> 2.2.0'
gem 'em-mongo'

platforms :mri_19 do
  # Using Fibers + async callbacks to emulate synchronous programming
  gem 'em-synchrony', '~> 1.0.0'
end

# Generic interface to multiple Ruby template engines - https://github.com/rtomayko/tilt
# gem 'tilt'

group :development do
  gem 'heroku'
  gem 'bundler'
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
