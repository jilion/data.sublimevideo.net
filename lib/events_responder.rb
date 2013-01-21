require 'video_tag_md5_hash'
require 'workers/video_tag_updater_worker'

class EventsResponder
  attr_reader :site_token, :params

  def initialize(site_token, params)
    @site_token = site_token
    @params = params
  end

  def response
    response = []
    events do |event, data|
      response << send("#{event}_event_response", data)
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
    params.each do |event_data|
      if event = event_data.delete('e')
        block.call(event, event_data)
      end
    end
  end

end
