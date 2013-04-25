require 'sidekiq'

class StatsHandlerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'stats'

  def perform(site_token, event_key, data)
    # method handled elsewhere
  end
end
