module Stat
  extend ActiveSupport::Concern

  def self.inc_and_push_stats(params, user_agent)
    if %w[m e].include?(params[:h]) && !params.key?(:em)
      incs = StatRequestParser.stat_incs(params, user_agent)
      second = Time.now.change(usec: 0).to_time
      inc_stats(incs, second) unless skipped_token?(params[:t])
      push_stats(incs, second)
    end
  rescue StatRequestParser::BadParamsError
  end

private

  def self.skipped_token?(token)
    [
      "2xrynuh2" # schooltube.com
    ].include?(token)
  end

  def self.inc_stats(incs, second)
    EM.defer do
      site = incs[:site]
      if site[:inc].present?
        Stat::Site::Second.collection.update({ t: site[:t], d: second }, { "$inc" => site[:inc] }, upsert: true)
      end
      incs[:videos].each do |video|
        if video[:inc].present?
          Stat::Video::Second.collection.update({ st: video[:st], u: video[:u], d: second }, { "$inc" => video[:inc] }, upsert: true)
        end
      end
    end
  end

  def self.push_stats(incs, second)
    channel = Pusher["private-#{incs[:site][:t]}"]
    trigger_async_if_channel_occupied(channel, incs, second)
  end

  def self.trigger_async_if_channel_occupied(channel, incs, second)
    request  = Pusher::Request.new(:get, channel.instance_variable_get(:@uri) + 'stats', {}, '')
    uri      = request.instance_variable_get(:@uri)
    params   = request.instance_variable_get(:@params)

    deferrable = EM::DefaultDeferrable.new
    http = EventMachine::HttpRequest.new(uri).get({
      :query => params, :timeout => 5,
      :head => {'Content-Type'=> 'application/json'}
    })
    http.callback {
      begin
        response = MultiJson.decode(http.response)
        if response['occupied']
          json = StatRequestParser.convert_incs_to_json(incs, second.to_i)
          channel.trigger_async('stats', json)
        end
        handle_response(http.response_header.status, http.response.chomp)
        deferrable.succeed
      rescue => e
        deferrable.fail(e)
      end
    }
    http.errback {
      Pusher.logger.debug("Network error connecting to pusher: #{http.inspect}")
      deferrable.fail(Error.new("Network error connecting to pusher"))
    }
    deferrable
  end

end
