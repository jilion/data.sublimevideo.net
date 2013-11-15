require 'sidekiq'

class VideoTagStartHandlerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'videos'

  def perform(site_token, uid, data)
    # method handled elsewhere
  end
end
