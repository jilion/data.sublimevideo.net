require 'spec_helper'

require 'workers/stats_handler_worker'

describe StatsHandlerWorker do
  it "delays job in stats queue" do
    StatsHandlerWorker.sidekiq_options_hash['queue'].should eq 'stats'
  end
end