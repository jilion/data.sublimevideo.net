module Stat
  extend ActiveSupport::Concern

  included do
    # DateTime periods
    field :s,  :type => DateTime  # Second
  end

  # =================
  # = Class Methods =
  # =================

  def self.inc_and_push_stats(params, user_agent)
    if %w[m e].include?(params[:h]) && !params.key?(:em)
      incs = StatRequestParser.stat_incs(params, user_agent)
      second = Time.now.change(usec: 0).to_time
      inc_stats(incs, second)
      push_stats(incs, second)
    end
  rescue StatRequestParser::BadParamsError
  end

private

  def self.inc_stats(incs, second)
    EM.defer do
      site = incs[:site]
      if site[:inc].present?
        Stat::Site.collection.update({ t: site[:t], s: second }, { "$inc" => site[:inc] }, upsert: true)
      end
      incs[:videos].each do |video|
        if video[:inc].present?
          Stat::Video.collection.update({ st: video[:st], u: video[:u], s: second }, { "$inc" => video[:inc] }, upsert: true)
        end
      end
    end
  end

  def self.push_stats(incs, second)
    json = StatRequestParser.convert_incs_to_json(incs, second.to_i)
    Pusher["private-#{incs[:site][:t]}"].trigger_async('stats', json)
  end

end
