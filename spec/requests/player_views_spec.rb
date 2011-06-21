require 'spec_helper'

describe PlayerViewsController do
  let(:err) { Proc.new { fail "API request failed" } }
  let(:today) { Date.today.to_datetime.to_time.utc }

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

  it "increments SiteUsage player_views" do
    site_usage = SiteUsage.create(site_token: '12345678', day: today)
    site_usage.player_views.should == 0
    with_api(App) do
      get_request({:path => '/p/12345678'}, err) do |cb|
        cb.response_header.status.should == 200
        cb.response.should == 'sublimevideo.pInc=true'
      end
    end
    site_usage.reload.player_views.should == 1
  end

end