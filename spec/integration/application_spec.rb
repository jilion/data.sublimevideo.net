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
    last_response.status.should eq 301
    last_response.body.should eq "Redirect to http://sublimevideo.net"
  end

  it "responds on HEAD" do
    head '/'
    last_response.status.should eq 200
    last_response.body.should be_empty
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

  context "on /_.gif path" do
    let(:site_token) { 'abcd1234' }
    let(:uid) { 'uid' }

    it "doesn't cache gif" do
      get "/_.gif"
      last_response.header['Cache-Control'].should eq 'no-cache'
    end

    context "without site_token params" do
      it "responses with transparent gif" do
        get "/_.gif"
        last_response.header['Content-Type'].should eq 'image/gif'
      end

      it "doesn't delay stats handling" do
        get '/_.gif'
        Sidekiq::Worker.jobs.should have(0).job
      end
    end

    context "al, l & s events" do
      let(:data) { [{ 'e' => 'al' }, { 'e' => 'l' }, { 'e' => 's' }] }

      it "delays stats handling" do
        get "/_.gif?i=#{Time.now.to_i}&s=#{site_token}&d=#{URI.escape(MultiJson.dump(data))}"
        StatsHandlerWorker.jobs.should have(3).job
        StatsHandlerWorker.jobs.first['args'].should eq [site_token, 'al', {
          't' => kind_of(Integer), 'ua' => nil, 'ip' => '127.0.0.1'
        }]
        Sidekiq::Worker.jobs.to_s.should match /StatsHandler/
      end

      it "responses with transparent gif" do
        get "/_.gif?i=#{Time.now.to_i}&s=#{site_token}&d=#{URI.escape(MultiJson.dump(data))}"
        last_response.header['Content-Type'].should eq 'image/gif'
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
      headers['Access-Control-Allow-Origin'].should eq '*'
      headers['Access-Control-Allow-Methods'].should eq 'POST'
      headers['Access-Control-Allow-Headers'].should eq 'Content-Type'
      headers['Access-Control-Max-Age'].should eq '1728000'
    end

    it "responses with CORS headers on POST" do
      post "/#{site_token}.json"
      last_response.header['Access-Control-Allow-Origin'].should eq '*'
    end

    it "always responds in JSON" do
      post "/#{site_token}.json", nil, 'Content-Type' => 'text/plain'
      last_response.body.should eq "[]"
    end

    context "NEW CORS PROTOCOL" do
      context "al event" do
        let(:al_data) { [{ 'e' => 'al' }] }

        it "delays stats handling" do
          post "/#{site_token}.json", MultiJson.dump(al_data)
          Sidekiq::Worker.jobs.should have(1).job
          Sidekiq::Worker.jobs.to_s.should match /StatsHandler/
        end

        it "responses and empty array" do
          post "/#{site_token}.json", MultiJson.dump(al_data)
          last_response.body.should eq "[]"
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
          body.should eq([
            { 'e' => 'l', 'u' => uid, 'h' => crc32_hash },
            { 'e' => 'l', 'u' => 'other_uid', 'h' => nil }
          ])
        end

        it "delays stats handling" do
          post "/#{site_token}.json", MultiJson.dump(l_data)
          Sidekiq::Worker.jobs.should have(2).job
          Sidekiq::Worker.jobs.to_s.should match /StatsHandler/
        end
      end

      context "s event" do
        let(:s_data) { [{ 'e' => 's' }] }

        it "delays stats handling" do
          post "/#{site_token}.json", MultiJson.dump(s_data)
          Sidekiq::Worker.jobs.should have(1).job
          Sidekiq::Worker.jobs.to_s.should match /StatsHandler/
        end

        it "responses and empty array" do
          post "/#{site_token}.json", MultiJson.dump(s_data)
          last_response.body.should eq "[]"
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
          Sidekiq::Worker.jobs.should have(1).job
          Sidekiq::Worker.jobs.to_s.should match /VideoTagUpdater/
        end

        it "responses and empty array" do
          post "/#{site_token}.json", MultiJson.dump(v_data)
          last_response.body.should eq "[]"
        end
      end
    end

    context "OLD CORS PROTOCOL" do
      let(:v_data) { [
        { 'v' => { 'u' => uid, 'h' => crc32_hash, 't' => 'Video Title', 'a' => { "data" => "settings" } } }
      ] }

      context "h event" do
        let(:h_data) { [
          { 'h' => { 'u' => uid } },
          { 'h' => { 'u' => 'other_uid' } }
        ] }

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

      context "v event" do
        let(:uid) { 'uid' }
        let(:crc32_hash) { 'crc32_hash' }

        it "delays update on VideoTagUpdater" do
          post "/#{site_token}.json", MultiJson.dump(v_data)
          Sidekiq::Worker.jobs.should have(1).job
          Sidekiq::Worker.jobs.to_s.should match /VideoTagUpdater/
        end

        it "responses and empty array" do
          post "/#{site_token}.json", MultiJson.dump(v_data)
          last_response.body.should eq "[]"
        end
      end
    end
  end
end
