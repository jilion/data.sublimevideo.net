require 'spec_helper'

require 'workers/stats_with_addon_handler_worker'

describe StatsWithAddonHandlerWorker do
  it "delays job in stats queue" do
    expect(StatsWithAddonHandlerWorker.sidekiq_options_hash['queue']).to eq 'stats'
  end
end
