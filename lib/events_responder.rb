require 'video_tag_crc32_hash'
require 'workers/stats_handler_worker'
require 'workers/video_tag_updater_worker'
require 'workers/video_tag_duration_updater_worker'

class EventsResponder
  EVENT_KEYS = %w[h v l al s]

  attr_reader :site_token, :request, :params

  def initialize(site_token, params, request)
    @site_token = site_token
    @request = request
    @params = params
  end

  def response
    response = []
    _events do |event_key, data|
      response << send("_#{event_key}_event_response", data)
      Librato.increment 'data.events_type', source: event_key
    end
    response.compact
  end

  private

  def _al_event_response(data)
    _delay_stats_handling(:al, data)
    nil
  end

  def _l_event_response(data)
    _delay_stats_handling(:l, data)
    if uid = data.delete('u')
      crc32 = _video_tag_crc32_hash(uid).get
      { e: 'l', u: uid, h: crc32 }
    end
  end

  def _s_event_response(data)
    _delay_stats_handling(:s, data.dup)
    _delay_video_tag_duration_update(data.dup)
    nil
  end

  def _v_event_response(data)
    _delay_video_tag_update(data)
  rescue => ex
    Honeybadger.notify_or_ignore(ex)
  ensure
    return nil
  end

  def _events(&block)
    return unless params.is_a?(Array)
    params.each do |data|
      if event_key = data.delete('e') # New protocol only
        block.call(event_key, data)
      end
    end
  end

  def _video_tag_crc32_hash(uid)
    VideoTagCRC32Hash.new(site_token, uid)
  end

  def _delay_stats_handling(event_key, data)
    StatsHandlerWorker.perform_async(event_key, data.merge(_request_data))
  end

  def _delay_video_tag_update(data)
    uid = data.delete('u')
    crc32 = data.delete('h')
    unless crc32 == _video_tag_crc32_hash(uid).get
      _video_tag_crc32_hash(uid).set(crc32)
      VideoTagUpdaterWorker.perform_async(site_token, uid, data)
    end
  end

  def _delay_video_tag_duration_update(data)
    uid = data.delete('u')
    duration = data.delete('vd')
    if uid && duration
      VideoTagDurationUpdaterWorker.perform_async(site_token, uid, duration)
    end
  end

  def _request_data
    { 's'  => site_token,
      't'  => Time.now.to_i,
      'ua' => request.user_agent,
      'ip' => request.ip }
  end
end
