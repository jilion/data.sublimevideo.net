source :rubygems

gem "hiredis", "~> 0.3.1"
gem "em-synchrony"
gem "redis", "~> 2.2.0", :require => ["redis/connection/synchrony", "redis"]
gem "goliath", :git => "https://github.com/postrank-labs/goliath.git"
gem "yajl-ruby"

# gem 'goliath', :git => 'git://github.com/postrank-labs/goliath.git' #, :ref => 'f96bd2dc08895a56882fb621efb5ccc36635d50f'
# gem 'em-http-request', :git => 'git://github.com/igrigorik/em-http-request.git'
# gem 'em-synchrony', :git => 'git://github.com/igrigorik/em-synchrony.git'
# gem 'yajl-ruby'
#
# gem 'em-hiredis'

gem 'hoptoad_notifier'

group :development do
  gem 'bundler', '1.1.pre.5'
  gem 'foreman'
  gem 'heroku'

  gem 'rb-fsevent'
  gem 'growl'
  gem 'guard', :git => 'git://github.com/guard/guard.git'
  gem 'guard-rspec'
end

group :test do
  gem 'rspec', '>2.0'
end
