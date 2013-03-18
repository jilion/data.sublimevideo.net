require 'video_tag_crc32_hash'
require 'workers/video_tag_updater_worker'

class EventsResponder
  EVENT_KEYS = %w[h v]

  attr_reader :site_token, :uid, :params

  def initialize(site_token, params)
    @site_token = site_token
    @params     = params
  end

  def response
    response = []
    events do |event_key, data|
      @uid = data.delete('u')
      response << send("#{event_key}_event_response", data)
      increment_metrics(event_key)
    end
    response.compact
  end

  private

  def h_event_response(data)
    crc32 = video_tag_crc32_hash.get
    { h: { u: uid, h: crc32 } }
  rescue => e
    Airbrake.notify_or_ignore(e)
    { h: { u: uid, h: nil } }
  end

  def v_event_response(data)
    crc32 = data.delete('h')
    video_tag_crc32_hash.set(crc32)
    VideoTagUpdaterWorker.perform_async(site_token, uid, data)
    nil
  rescue => e
    Airbrake.notify_or_ignore(e)
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

  def increment_metrics(event_key)
    $metrics_queue.add("data.events_type" => { value: 1, source: event_key })
  end

  def video_tag_crc32_hash
    VideoTagCRC32Hash.new(site_token, uid)
  end
end
