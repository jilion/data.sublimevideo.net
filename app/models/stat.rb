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
    channel_name = "private-#{incs[:site][:t]}"
    if $redis.sismember("pusher:channels", channel_name)
      json = StatRequestParser.convert_incs_to_json(incs, second.to_i)
      Pusher[channel_name].trigger_async('stats', json)
    end
  end

end
