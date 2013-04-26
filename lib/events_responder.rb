require 'video_tag_crc32_hash'
require 'workers/stats_handler_worker'
require 'workers/video_tag_updater_worker'

class EventsResponder
  EVENT_KEYS = %w[h v l al s]

  attr_reader :site_token, :uid, :request, :params

  def initialize(site_token, params, request)
    @site_token = site_token
    @request = request
    @params = params
  end

  def response
    response = []
    events do |event_key, data|
      response << send("#{event_key}_event_response", data)
      Librato.increment 'data.events_type', source: event_key
    end
    response.compact
  end

  private

  def al_event_response(data)
    delay_stats_handling(:al, data)
    nil
  end

  def l_event_response(data)
    delay_stats_handling(:l, data)
    if @uid = data.delete('u')
      crc32 = video_tag_crc32_hash.get
      { e: 'l', u: uid, h: crc32 }
    end
  end

  def s_event_response(data)
    delay_stats_handling(:s, data)
    nil
  end

  # Old protocol
  def h_event_response(data)
    @uid = data.delete('u')
    crc32 = video_tag_crc32_hash.get
    { h: { u: uid, h: crc32 } }
  end

  def v_event_response(data)
    @uid = data.delete('u')
    crc32 = data.delete('h')
    video_tag_crc32_hash.set(crc32)
    VideoTagUpdaterWorker.perform_async(site_token, uid, data)
  rescue => ex
    Honeybadger.notify_or_ignore(ex)
  ensure
    return nil
  end

  def events(&block)
    return unless params.is_a?(Array)
    params.each do |event|
      if EVENT_KEYS.include?(event['e']) # New protocol
        block.call(event.delete('e'), event)
      else # Old protocol
        event_key, data = event.flatten
        block.call(event_key, data) if EVENT_KEYS.include?(event_key)
      end
    end
  end

  def video_tag_crc32_hash
    VideoTagCRC32Hash.new(site_token, uid)
  end

  def delay_stats_handling(event_key, data)
    StatsHandlerWorker.perform_async(event_key, data.merge(request_data))
  end

  def request_data
    {
      's'  => site_token,
      't'  => Time.now.to_i,
      'ua' => request.user_agent,
      'ip' => request.ip
    }
  end
end
