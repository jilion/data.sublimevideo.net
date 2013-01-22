require 'spec_helper'

describe Application do
  it "redirects to sublimevideo on GET" do
    with_api(Application) do |a|
      get_request(path: '/foo') do |api|
        api.response_header.status.should eq 301
        api.response.should eq "Redirect to http://sublimevideo.net"
      end
    end
  end

  context "on /status path" do
    it "responses OK on GET /status" do
      with_api(Application) do |a|
        get_request(path: '/status') do |api|
          api.response.should eq 'OK'
        end
      end
    end

    it "responses OK on POST /status" do
      with_api(Application) do |a|
        post_request(path: '/status') do |api|
          api.response.should eq 'OK'
        end
      end
    end
  end

  context "on /<site token>.json path" do
    let(:site_token) { 'abcd1234' }
    let(:path) { "/#{site_token}.json" }

    it "responses with CORS headers on OPTIONS" do
      with_api(Application) do |a|
        options_request(path: path) do |api|
          headers = api.response_header
          headers['Access-Control-Allow-Origin'].should eq '*'
          headers['Access-Control-Allow-Methods'].should eq 'POST'
          headers['Access-Control-Allow-Headers'].should eq 'Content-Type'
          headers['Access-Control-Allow-Credentials'].should eq 'true'
          headers['Access-Control-Max-Age'].should eq '1728000'
        end
      end
    end

    it "responses with CORS headers on POST" do
      with_api(Application) do |a|
        post_request(path: path) do |api|
          headers = api.response_header
          headers['Access-Control-Allow-Origin'].should eq '*'
        end
      end
    end

    it "always responds in JSON" do
      headers = { 'Content-Type' => 'text/plain' }
      with_api(Application) do |a|
        post_request(path: path, head: headers) do |api|
          body = MultiJson.load(api.response)
          body.should eq([])
        end
      end
    end

    context "with h event" do
      let(:uid) { 'uid' }
      let(:crc32_hash) { 'crc32_hash' }

      before { with_api(Application) { VideoTagCRC32Hash.set(site_token, uid , crc32_hash); stop } }

      it "responses with VideoTag data CRC32 hash" do
        data = [
          { 'h' => { 'u' => uid } },
          { 'h' => { 'u' => 'other_uid' } }
        ]
        with_api(Application) do |a|
          post_request(path: path, body: MultiJson.dump(data)) do |api|
            body = MultiJson.load(api.response)
            body.should eq([
              { "h" => { uid => crc32_hash } },
              { "h" => { 'other_uid' => nil } }
            ])
          end
        end
      end
    end

    context "with e=v requests" do
      let(:uid) { 'uid' }
      let(:crc32_hash) { 'crc32_hash' }
      let(:data) { [
        { 'v' => { 'u' => uid, 'h' => crc32_hash, 'uo' => 'a', 't' => { "data" => "settings" } } },
      ] }
      before { with_api(Application) { VideoTagCRC32Hash.set(site_token, uid , 'old_crc32_hash'); stop } }

      it "sets VideoTag data CRC32 hash" do
        with_api(Application) do |a|
          post_request(path: path, body: MultiJson.dump(data)) do |api|
            VideoTagCRC32Hash.get(site_token, uid).should eq crc32_hash
          end
        end
      end

      it "delays update on VideoTagUpdater" do
        with_api(Application) do |a|
          post_request(path: path, body: MultiJson.dump(data)) do |api|
            Sidekiq::Worker.jobs.should have(1).job
            Sidekiq::Worker.jobs.to_s.should match /VideoTagUpdater/
          end
        end
      end

      it "responses and empty array" do
        with_api(Application) do |a|
          post_request(path: path, body: MultiJson.dump(data)) do |api|
            body = MultiJson.load(api.response)
            body.should eq []
          end
        end
      end
    end

  end

end
