require 'spec_helper'

require 'workers/stats_without_addon_handler_worker'

describe StatsWithoutAddonHandlerWorker do
  it "delays job in stats queue" do
    expect(StatsWithoutAddonHandlerWorker.sidekiq_options_hash['queue']).to eq 'stats-slow'
  end
end
