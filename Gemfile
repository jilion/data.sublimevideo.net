source :rubygems

gem 'cramp'

# Async webserver for running a cramp application
gem 'thin'

# Rack based routing
gem 'http_router'

# Collection of async-proof rack middlewares - https://github.com/rkh/async-rack.git
gem 'async-rack'


# For stats parsing
gem 'addressable'
gem 'useragent',  :git => 'git://github.com/Jilion/useragent.git'


# For async Active Record models

# gem 'mysql2', '~> 0.2.11'
# gem 'activerecord', :require => 'active_record'

# For Mongoid.
gem 'bson_ext', '~> 1.3'
gem 'mongoid'
gem 'em-mongo'

platforms :mri_19 do
# Using Fibers + async callbacks to emulate synchronous programming
#  gem 'em-synchrony'
end

# Generic interface to multiple Ruby template engines - https://github.com/rtomayko/tilt
# gem 'tilt'

group :development do
  # Development gems
  # gem 'ruby-debug19'
end
