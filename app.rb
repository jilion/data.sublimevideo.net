require 'yajl'
require 'hoptoad_notifier'
require 'goliath'
require 'em-synchrony'
require 'mongoid'
require 'em-synchrony/mongo'

Dir.glob(File.dirname(__FILE__) + '/app/**/*.rb', &method(:require))

class App < Goliath::API
  use Goliath::Rack::Params
  use Goliath::Rack::Hoptoad


  get "/p/:site_token", :site_token => /^[a-z0-9]{8}$/ do
    run PlayerViewsController.new
  end

  map '/' do
    run Proc.new { |env| [404, {"Content-Type" => "text/html"}, ["Hello I'm an awesome data server!"]] }
  end
end
