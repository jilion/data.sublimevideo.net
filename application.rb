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
      end
    end

  end
end

Bundler.require(:default, DataSublimeVideo::Application.env)
require 'em-synchrony/em-http'
require 'em-synchrony/em-mongo'

# Preload application classes
require './app/models/stat'
Dir['./app/**/*.rb'].each { |f| require f }
