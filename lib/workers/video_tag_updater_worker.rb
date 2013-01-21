require 'sidekiq'

class VideoTagUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low

  def perform(site_token, uid, data)
    # method handled elsewhere
  end
end
