require 'video_tag_md5_hash'
require 'workers/video_tag_updater_worker'

class EventsResponder
  EVENT_KEYS = %w[h v]

  attr_reader :site_token, :params

  def initialize(site_token, params)
    @site_token = site_token
    @params = params
  end

  def response
    response = []
    events do |event_key, data|
      response << send("#{event_key}_event_response", data)
    end
    response.compact
  end

  private

  def h_event_response(data)
    uid = data.delete('u')
    md5 = VideoTagMD5Hash.get(site_token, uid)
    { h: { uid => md5 } }
  end

  def v_event_response(data)
    uid = data.delete('u')
    md5 = data.delete('h')
    VideoTagMD5Hash.set(site_token, uid, md5)
    VideoTagUpdaterWorker.perform_async(site_token, uid, data)
    nil
  end

  def events(&block)
    return unless params.is_a?(Array)
    params.each do |event|
      event_key, data = event.flatten
      if EVENT_KEYS.include?(event_key)
        block.call(event_key, data)
      end
    end
  end

end
