require 'video_tag_crc32_hash'
require 'workers/stats_with_addon_handler_worker'
require 'workers/stats_without_addon_handler_worker'
require 'workers/video_tag_updater_worker'
require 'workers/video_tag_start_handler_worker'

class EventsResponder
  EVENT_KEYS = %w[h v l al s]

  attr_reader :env, :site_token, :request, :events

  def initialize(env)
    @env = env
    @site_token = env['data.site_token']
    @events = env['data.events']
    @request = Rack::Request.new(env)
  end

  def response
    response = []
    _events do |event_key, data|
      response << send("_#{event_key}_event_response", data)
      Librato.increment 'data.events_type', source: event_key
      Librato.increment 'data.player_version', source: _player_version
    end
    response.compact
  end

  private

  def _al_event_response(data)
    _delay_stats_handling(:al, data)
    nil
  end

  def _l_event_response(data)
    Librato.increment "temp.loads.#{_player_version}", source: 'new'
    _delay_stats_handling(:l, data)
    if uid = data.delete('u')
      crc32 = _video_tag_crc32_hash(uid).get
      { e: 'l', u: uid, h: crc32 }
    end
  end

  def _s_event_response(data)
    Librato.increment "temp.starts.#{_player_version}", source: 'new'
    _delay_stats_handling(:s, data.dup)
    _delay_video_tag_start_handler(data.dup)
    nil
  end

  def _v_event_response(data)
    _delay_video_tag_update(data)
    nil
  end

  def _events
    events.each { |data| yield(data.delete('e'), data) }
  rescue => ex
    Honeybadger.notify_or_ignore(ex, error_message: 'Events are invalid', context: { events: events }, rack_env: env)
    nil
  end

  def _video_tag_crc32_hash(uid)
    VideoTagCRC32Hash.new(site_token, uid)
  end

  def _delay_stats_handling(event_key, data)
    stats_handler_class = data['sa'] ? StatsWithAddonHandlerWorker : StatsWithoutAddonHandlerWorker
    stats_handler_class.perform_async(event_key, data.merge(_request_data))
  end

  def _delay_video_tag_update(data)
    uid = data.delete('u')
    crc32 = data.delete('h')
    unless crc32 == _video_tag_crc32_hash(uid).get
      _video_tag_crc32_hash(uid).set(crc32)
      VideoTagUpdaterWorker.perform_async(site_token, uid, data)
    end
  end

  def _delay_video_tag_start_handler(data)
    if uid = data.delete('u')
      data = { t: Time.now.utc, vd: data.delete('vd') } # duration only
      VideoTagStartHandlerWorker.perform_async(site_token, uid, data)
    end
  end

  def _request_data
    { 's'  => site_token,
      't'  => Time.now.to_i,
      'ua' => request.user_agent,
      'ip' => request.ip }
  end

  def _player_version
    request.params.fetch('v', 'none')
  end
end
