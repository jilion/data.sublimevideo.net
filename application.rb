require 'rubygems'
require 'bundler'

module DataSublimeVideo
  class Application

    def self.root(path = nil)
      @_root ||= File.expand_path(File.dirname(__FILE__))
      path ? File.join(@_root, path.to_s) : @_root
    end

    def self.env
      @_env ||= ENV['RACK_ENV'] || 'development'
    end

    def self.routes
      @_routes ||= eval(File.read('./config/routes.rb'))
    end

    # Initialize the application
    def self.initialize!
      EM::next_tick do
        Pusher.url = PusherConfig.url
        Mongoid.load!(File.join(DataSublimeVideo::Application.root, 'config', 'mongoid.yml'))
        $redis = Redis.connect(url: ENV['OPENREDIS_URL'] || 'redis://127.0.0.1:6379')
      end
    end

  end
end

Bundler.require(:default, DataSublimeVideo::Application.env)
require 'em-synchrony/em-http'
require 'em-synchrony/em-mongo'
require_all 'app'
