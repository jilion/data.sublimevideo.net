require 'spec_helper'
require 'rack/test'
APP = Rack::Builder.parse_file('config.ru').first
require 'sidekiq/testing'

describe Application do
  include Rack::Test::Methods

  def app
    APP
  end

  it "redirects to sublimevideo on GET" do
    get '/foo'
    last_response.status.should eq 301
    last_response.body.should eq "Redirect to http://sublimevideo.net"
  end

  context "on /status path" do
    it "responses OK on GET /status" do
      get '/status'
      last_response.body.should eq 'OK'
    end

    it "responses OK on POST /status" do
      post '/status'
      last_response.body.should eq 'OK'
    end
  end

  context "on /<site token>.json path" do
    let(:site_token) { 'abcd1234' }
    let(:uid) { 'uid' }
    let(:crc32_hash) { 'crc32_hash' }
    let(:h_data) { [
      { 'h' => { 'u' => uid } },
      { 'h' => { 'u' => 'other_uid' } }
    ] }
    let(:v_data) { [
      { 'v' => { 'u' => uid, 'h' => crc32_hash, 't' => 'Video Title', 'a' => { "data" => "settings" } } }
    ] }

    it "responses with CORS headers on OPTIONS" do
      options "/#{site_token}.json"
      headers = last_response.header
      headers['Access-Control-Allow-Origin'].should eq '*'
      headers['Access-Control-Allow-Methods'].should eq 'POST'
      headers['Access-Control-Allow-Headers'].should eq 'Content-Type'
      headers['Access-Control-Allow-Credentials'].should eq 'true'
      headers['Access-Control-Max-Age'].should eq '1728000'
    end

    it "responses with CORS headers on POST" do
      post "/#{site_token}.json"
      last_response.header['Access-Control-Allow-Origin'].should eq '*'
    end

    it "always responds in JSON" do
      post "/#{site_token}.json", nil, 'Content-Type' => 'text/plain'
      body = MultiJson.load(last_response.body)
      body.should eq([])
    end

    context "with h event" do
      before { post "/#{site_token}.json", MultiJson.dump(v_data) }

      it "responses with VideoTag data CRC32 hash" do
        post "/#{site_token}.json", MultiJson.dump(h_data)
        body = MultiJson.load(last_response.body)
        body.should eq([
          { 'h' => { 'u' => uid, 'h' => crc32_hash } },
          { 'h' => { 'u' => 'other_uid', 'h' => nil } }
        ])
      end
    end

    context "with e=v requests" do
      let(:uid) { 'uid' }
      let(:crc32_hash) { 'crc32_hash' }

      it "delays update on VideoTagUpdater" do
        post "/#{site_token}.json", MultiJson.dump(v_data)
        Sidekiq::Worker.jobs.should have(1).job
        Sidekiq::Worker.jobs.to_s.should match /VideoTagUpdater/
      end

      it "responses and empty array" do
        post "/#{site_token}.json", MultiJson.dump(v_data)
        body = MultiJson.load(last_response.body)
        body.should eq []
      end
    end
  end
end
