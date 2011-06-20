require 'spec_helper'

describe PlayerViewsController do
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
          # SiteUsage.where(site_token: "12345678").first
          # p SiteUsage.count
          # p SiteUsage.all.entries
        end
      end
    end
  end

end