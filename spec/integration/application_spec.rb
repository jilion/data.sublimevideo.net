require 'spec_helper'
require 'rack/test'
APP = Rack::Builder.parse_file('config.ru').first
require 'sidekiq/testing'

describe Application do
  include Rack::Test::Methods
  before { Sidekiq::Worker.jobs.clear }

  def app
    APP
  end

  it "redirects to sublimevideo on GET" do
    get '/foo'
    expect(last_response.status).to eq 301
    expect(last_response.body).to eq "Redirect to http://sublimevideo.net"
  end

  it "responds on HEAD" do
    head '/_.gif?s=abcd1234'
    expect(last_response.status).to eq 200
    expect(last_response.body).to be_empty
  end

  context "on /status path" do
    it "responses OK on GET /status" do
      get '/status'
      expect(last_response.body).to eq 'OK'
    end

    it "responses OK on POST /status" do
      post '/status'
      expect(last_response.body).to eq 'OK'
    end
  end

  context "on /_.gif path" do
    let(:data) { [] }
    let(:site_token) { 'abcd1234' }
    let(:uid) { 'uid' }
    let(:url) { "/_.gif?i=#{Time.now.to_i}&s=#{site_token}&d=#{CGI.escape(MultiJson.dump(data))}" }

    it "doesn't cache gif" do
      get url
      expect(last_response.header['Cache-Control']).to eq 'no-cache'
    end

    context "without site_token params" do
      it "responses with transparent gif" do
        get url
        expect(last_response.header['Content-Type']).to eq 'image/gif'
      end

      it "doesn't delay stats handling" do
        get url
        expect(Sidekiq::Worker.jobs).to have(0).job
      end
    end

    context "al, l & s events" do
      let(:data) { [{ 'e' => 'al' }, { 'e' => 'l' }, { 'e' => 's' }] }

      it "delays stats handling (GET request)" do
        get url
        expect(StatsWithoutAddonHandlerWorker.jobs).to have(3).job
        expect(StatsWithoutAddonHandlerWorker.jobs.first['args']).to eq [
          'al',
          't' => kind_of(Integer), 's' => site_token, 'ua' => nil, 'ip' => '127.0.0.1'
        ]
        expect(Sidekiq::Worker.jobs.to_s).to match /StatsWithoutAddonHandler/
      end

      it "delays stats handling (HEAD request)" do
        head url
        expect(StatsWithoutAddonHandlerWorker.jobs).to have(3).job
        expect(StatsWithoutAddonHandlerWorker.jobs.first['args']).to eq [
          'al',
          't' => kind_of(Integer), 's' => site_token, 'ua' => nil, 'ip' => '127.0.0.1'
        ]
        expect(Sidekiq::Worker.jobs.to_s).to match /StatsWithoutAddonHandler/
        expect(last_response.body).to be_empty
      end

      it "responses with transparent gif" do
        get url
        expect(last_response.header['Content-Type']).to eq 'image/gif'
      end
    end

  end

  context "on /_.gif path (bugged d params)" do
    let(:site_token) { 'abcd1234' }
    let(:url) { "/_.gif?i=#{Time.now.to_i}&s=#{site_token}&%5B%7B%22e%22%3A%22s%22%2C%22ho%22%3A%22m%22%2C%22de%22%3A%22d%22%2C%22te%22%3A%22f%22%2C%22em%22%3Atrue%2C%22du%22%3A%22http%3A%2F%2Fubdavid.org%2Fadvanced%2Fpractical%2Fpractical-christian_01.html%22%2C%22vsr%22%3A%22256x174%22%2C%22vd%22%3A30023%7D%5D" }

    context "al, l & s events" do

      it "delays stats handling (GET request)" do
        get url
        expect(StatsWithoutAddonHandlerWorker.jobs).to have(1).job
      end

      it "responses with transparent gif" do
        get url
        expect(last_response.header['Content-Type']).to eq 'image/gif'
      end
    end
  end

  context "on /<site token>.json path" do
    let(:site_token) { 'abcd1234' }
    let(:uid) { 'uid' }
    let(:crc32_hash) { 'crc32_hash' }

    it "responses with CORS headers on OPTIONS" do
      options "/#{site_token}.json"
      headers = last_response.header
      expect(headers['Access-Control-Allow-Origin']).to eq '*'
      expect(headers['Access-Control-Allow-Methods']).to eq 'POST'
      expect(headers['Access-Control-Allow-Headers']).to eq 'Content-Type'
      expect(headers['Access-Control-Max-Age']).to eq '1728000'
    end

    it "responses with CORS headers on POST" do
      post "/#{site_token}.json"
      expect(last_response.header['Access-Control-Allow-Origin']).to eq '*'
    end

    it "always responds in JSON" do
      post "/#{site_token}.json", nil, 'Content-Type' => 'text/plain'
      expect(last_response.body).to eq "[]"
    end

    context "al event" do
      let(:al_data) { [{ 'e' => 'al', 'sa' => true }] }

      it "delays stats handling" do
        post "/#{site_token}.json", MultiJson.dump(al_data)
        expect(Sidekiq::Worker.jobs).to have(1).job
        expect(Sidekiq::Worker.jobs.to_s).to match /StatsWithAddonHandler/
      end

      it "responses and empty array" do
        post "/#{site_token}.json", MultiJson.dump(al_data)
        expect(last_response.body).to eq "[]"
      end
    end

    context "l event" do
      let(:uid) { 'uid' }
      let(:crc32_hash) { 'crc32_hash' }
      let(:v_data) { [{ 'e' => 'v', 'u' => uid, 'h' => crc32_hash }] }
      let(:l_data) { [
        { 'e' => 'l', 'u' => uid },
        { 'e' => 'l', 'u' => 'other_uid' }
      ] }
      before { post "/#{site_token}.json", MultiJson.dump(v_data) }

      it "responses with VideoTag data CRC32 hash" do
        post "/#{site_token}.json", MultiJson.dump(l_data)
        body = MultiJson.load(last_response.body)
        expect(body).to eq([
          { 'e' => 'l', 'u' => uid, 'h' => crc32_hash },
          { 'e' => 'l', 'u' => 'other_uid', 'h' => nil }
        ])
      end

      it "delays stats handling" do
        post "/#{site_token}.json", MultiJson.dump(l_data)
        expect(Sidekiq::Worker.jobs).to have(2).job
        expect(Sidekiq::Worker.jobs.to_s).to match /StatsWithoutAddonHandler/
      end
    end

    context "s event" do
      let(:s_data) { [{ 'e' => 's' }] }

      it "delays stats handling" do
        post "/#{site_token}.json", MultiJson.dump(s_data)
        expect(Sidekiq::Worker.jobs).to have(1).job
        expect(Sidekiq::Worker.jobs.to_s).to match /StatsWithoutAddonHandler/
      end

      it "responses and empty array" do
        post "/#{site_token}.json", MultiJson.dump(s_data)
        expect(last_response.body).to eq "[]"
      end
    end

    context "v event" do
      let(:v_data) { [
        { 'e' => 'v', 'u' => uid, 'h' => crc32_hash, 't' => 'Video Title', 'a' => { "data" => "settings" } }
      ] }
      let(:uid) { 'uid' }
      let(:crc32_hash) { 'crc32_hash' }

      it "delays update on VideoTagUpdater" do
        post "/#{site_token}.json", MultiJson.dump(v_data)
        expect(Sidekiq::Worker.jobs).to have(1).job
        expect(Sidekiq::Worker.jobs.to_s).to match /VideoTagUpdater/
      end

      it "responses and empty array" do
        post "/#{site_token}.json", MultiJson.dump(v_data)
        expect(last_response.body).to eq "[]"
      end
    end

  end
end
