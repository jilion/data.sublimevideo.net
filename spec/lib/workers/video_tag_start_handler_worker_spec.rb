require 'spec_helper'

require 'workers/video_tag_start_handler_worker'

describe VideoTagStartHandlerWorker do
  it "delays job in videos queue" do
    expect(VideoTagStartHandlerWorker.sidekiq_options_hash['queue']).to eq 'videos'
  end
end
