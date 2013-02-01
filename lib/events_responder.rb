require 'video_tag_crc32_hash'
require 'workers/video_tag_updater_worker'

class EventsResponder
  EVENT_KEYS = %w[h v]

  attr_reader :env, :site_token, :params

  def initialize(env, site_token, params)
    @env        = env
    @site_token = site_token
    @params     = params
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
    crc32 = VideoTagCRC32Hash.new(env, site_token, uid).get
    { h: { u: uid, h: crc32 } }
  end

  def v_event_response(data)
    uid = data.delete('u')
    crc32 = data.delete('h')
    VideoTagCRC32Hash.new(env, site_token, uid).set(crc32)
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
