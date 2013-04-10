require 'rescue_me'
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
      response << send("#{event_key}_event_response", data)
      increment_metrics(event_key)
    end
    response.compact
  end

  private

  def h_event_response(data)
    @uid = data.delete('u')
    crc32 = video_tag_crc32_hash.get
    { h: { u: uid, h: crc32 } }
  end

  def v_event_response(data)
    @uid = data.delete('u')
    crc32 = data.delete('h')
    video_tag_crc32_hash.set(crc32)
    rescue_and_retry(3) {
      VideoTagUpdaterWorker.perform_async(site_token, uid, data)
    }
    nil
  rescue => ex
    Honeybadger.notify_or_ignore(ex)
    nil
  end

  def events(&block)
    return unless params.is_a?(Array)
    params.each do |event|
      event_key, data = event.flatten
      block.call(event_key, data) if EVENT_KEYS.include?(event_key)
    end
  end

  def increment_metrics(event_key)
    $metrics_queue.add("data.events_type" => { value: 1, source: event_key })
  end

  def video_tag_crc32_hash
    VideoTagCRC32Hash.new(site_token, uid)
  end
end
