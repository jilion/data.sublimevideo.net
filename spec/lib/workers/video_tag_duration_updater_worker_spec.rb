require 'spec_helper'

require 'workers/video_tag_duration_updater_worker'

describe VideoTagDurationUpdaterWorker do
  it "delays job in videos queue" do
    expect(VideoTagDurationUpdaterWorker.sidekiq_options_hash['queue']).to eq 'videos'
  end
end
