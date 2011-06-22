require 'spec_helper'

describe SiteUsage do
  let(:today) { Date.today.to_datetime.to_time.utc }

  # describe ".increment" do
  #
  #   it "increment player_views" do
  #     site_usage = SiteUsage.create(site_token: '12345678', day: today)
  #
  #     site_usage.player_views.should == 0
  #     SiteUsage.increment(site_usage.site_token, :player_views)
  #     site_usage.reload.player_views.should == 1
  #   end
  #
  #   it "set day in utc" do
  #     SiteUsage.increment('12345678', :player_views)
  #     SiteUsage.where(site_token: '12345678').first.day.should == today
  #   end
  #
  # end

end