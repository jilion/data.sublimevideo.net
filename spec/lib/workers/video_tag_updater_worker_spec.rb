require 'spec_helper'

require 'workers/video_tag_updater_worker'

describe VideoTagUpdaterWorker do
  it "delays job in videos queue" do
    expect(VideoTagUpdaterWorker.sidekiq_options_hash['queue']).to eq 'videos'
  end
end
