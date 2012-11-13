#!/usr/bin/env ruby
require "bundler"
Bundler.require

$: << File.dirname(__FILE__) + '/lib'
require 'rack/cors'
require 'rack/get_redirector'
require 'rack/json_parser'
require 'rack/json_formatter'
require 'rack/newrelic_stats_reporter'
require 'video_tag_data_md5_hash'
require 'video_tag_data_updater'

class Application < Goliath::API
  use Rack::NewrelicStatsReporter
  use Goliath::Rack::Heartbeat  # respond to /status with 200, OK (monitoring, etc)
  use Rack::GETRedirector       # add good headers for CORS
  use Rack::Cors                # add good headers for CORS
  use Rack::JSONParser          # always parse & merge body parameters as JSON
  use Rack::JSONFormatter       # always ouptut JSON

  def response(env)
    response = []
    if site_token = extract_site_token(env)
      events(params) do |event, data|
        video_uid = data.delete('u')
        case event
        when 'h'
          md5 = VideoTagDataMD5Hash.get(site_token, video_uid)
          response << { h: { video_uid => md5 } }
        when 'v'
          md5 = data.delete('h')
          VideoTagDataMD5Hash.set(site_token, video_uid, md5)
          VideoTagDataUpdater.delay(queue: 'low').update(site_token, video_uid, data)
        end
      end
    end
    [200, {}, response]
  end

  def events(params, &block)
    return unless params.is_a?(Array)
    params.each do |event_data|
      event = event_data.delete('e')
      block.call(event, event_data)
    end
  end

  def extract_site_token(env)
    matches = env['REQUEST_PATH'].match(%r{/([a-z0-9]{8}).json})
    matches && matches[1]
  end
end
