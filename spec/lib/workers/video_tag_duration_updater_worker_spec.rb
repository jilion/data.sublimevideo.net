require 'spec_helper'

require 'workers/video_tag_duration_updater_worker'

describe VideoTagDurationUpdaterWorker do
  it "delays job in videos queue" do
    VideoTagDurationUpdaterWorker.sidekiq_options_hash['queue'].should eq 'videos'
  end
end
