require 'spec_helper'

describe IncrPlayerViewsController do
  let(:err) { Proc.new { fail "API request failed" } }

  describe ":site_token validation" do
    it "fails with bad :site_token" do
      with_api(App) do
        get_request({:path => '/p/not_a_site_token'}, err) do |cb|
          cb.response_header.status.should == 404
        end
      end
    end

    it "success with good :site_token" do
      with_api(App) do
        get_request({:path => '/p/12345678'}, err) do |cb|
          cb.response_header.status.should == 200
        end
      end
    end
  end

  it "increments site token keys for the day" do
    with_api(App) do |api|
      redis = api.config['redis']
      token = '12345678'
      key   = today + token

      redis.hset key, 'p', 1
      get_request({:path => "/p/#{token}"}, err) do |cb|
        cb.response_header.status.should == 200
        cb.response.should == 'sublimevideo.pInc=true'
      end
      redis.hget(key, 'p').should eq("2")
    end
  end

end