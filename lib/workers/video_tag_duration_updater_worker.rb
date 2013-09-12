require 'sidekiq'

class VideoTagDurationUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'videos'

  def perform(site_token, uid, duration)
    # method handled elsewhere
  end
end
