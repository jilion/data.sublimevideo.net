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
    json = convert_incs_to_json(incs, second.to_i)
    Pusher["presence-#{incs[:site][:t]}"].trigger_async('stats', json)
  end

  # Convert StatRequestParser incs to json for Pusher
  #
  # { site: { id: ...}, videos: [ { id: ... u: } ]}
  #
  def self.convert_incs_to_json(incs, second)
    json = { site: {}, videos: [] }
    site = incs[:site]
    if site[:inc].present?
      json[:site] = { id: second }
      site[:inc].each do |key, value|
        case key
        when /^pv\./
          json[:site][:pv] = value
        when /^bp\./
          one_level_json_convert!(json[:site], key, value)
        when /^md\./
          double_level_json_convert!(json[:site], key, value)
        when /^vv\./
          json[:site][:vv] = value
        end
      end
    end
    incs[:videos].each do |video|
      if video[:inc].present?
        video_json = { id: second, u: video[:u] }
        video_json[:n] = video[:n] if video.key?(:n)
        video[:inc].each do |key, value|
          case key
          when /^vl\./
            video_json[:vl] = value
          when /^bp\./
            one_level_json_convert!(video_json, key, value)
          when /^md\./
            double_level_json_convert!(video_json, key, value)
          when /^vs\./
            one_level_json_convert!(video_json, key, value)
          when /^vv\./
            video_json[:vv] = value
          end
        end
        json[:videos] << video_json
      end
    end
    json
  end

  def self.one_level_json_convert!(json, key, value)
    keys = key.split('.')
    json[keys[0].to_sym] = { keys[1] => value }
  end

  def self.double_level_json_convert!(json, key, value)
    keys = key.split('.')
    json[keys[0].to_sym] ||= {}
    json[keys[0].to_sym][keys[1]] ||= {}
    json[keys[0].to_sym][keys[1]].merge!(keys[2] => value)
  end

end
