require 'spec_helper'

require 'workers/video_tag_updater_worker'

describe VideoTagUpdaterWorker do
  it "delays job in videos queue" do
    VideoTagUpdaterWorker.sidekiq_options_hash['queue'].should eq 'videos'
  end
end
