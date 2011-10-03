class SiteStat
  include Mongoid::Document

  field :t,  :type => String # Site token

  # DateTime periods
  field :s,  :type => DateTime  # Second

  field :pv, :type => Hash # Page Visits: { m (main) => 2, e (extra) => 10, d (dev) => 43, i (invalid) => 2 }
  field :vv, :type => Hash # Video Views: { m (main) => 1, e (extra) => 3, d (dev) => 11, i (invalid) => 1 }
  field :md, :type => Hash # Player Mode + Device hash { h (html5) => { d (desktop) => 2, m (mobile) => 1 }, f (flash) => ... }
  field :bp, :type => Hash # Browser + Plateform hash { "saf-win" => 2, "saf-osx" => 4, ...}

  # =================
  # = Class Methods =
  # =================

  def self.inc_stats_and_pusher(params, user_agent)
    if params.key?(:t) && %w[l p s].include?(params[:e]) && %w[m e].include?(params[:h])
      second    = Time.now.change(usec: 0).to_time
      inc, json = inc_and_json(params, user_agent)
      EM.defer do
        self.collection.update({ t: params[:t], s: second }, { "$inc" => inc }, upsert: true)
      end
      Pusher["presence-#{params[:t]}"].trigger_async('stats', json.merge(id: second.to_i))
    end
  end

private

  def self.inc_and_json(params, user_agent)
    inc, json = {}, {}
    case params[:e]
    when 'l' # Player load
      inc['pv.' + params[:h]] = 1 # Page Visits
      inc['bp.' + browser_and_platform_key(user_agent)] = 1 # Browser + Plateform
      json = { 'pv' => 1, 'bp' => { browser_and_platform_key(user_agent) => 1 } }
    when 'p' # Video prepare
      # Player Mode + Device hash
      if params.key?(:pm) && params.key?(:pd)
        json['md'] = { 'h' => {}, 'f' => {} }
        params[:pm].uniq.each do |pm|
          inc['md.' + pm + '.' + params[:pd]] = params[:pm].count(pm)
          json['md'][pm] = { params[:pd] => params[:pm].count(pm) }
        end
      end
    when 's' # Video start (play)
      # Video Views
      inc['vv.' + params[:h]] = 1
      json = { 'vv' => 1 }
    end
    [inc, json]
  end

  SUPPORTED_BROWSER = {
    "Firefox"           => "fir",
    "Chrome"            => "chr",
    "Internet Explorer" => "iex",
    "Safari"            => "saf",
    "Android"           => "and",
    "BlackBerry"        => "rim",
    "webOS"             => "weo",
    "Opera"             => "ope"
  }
  SUPPORTED_PLATEFORM = {
    "Windows"       => "win",
    "Macintosh"     => "osx",
    "iPad"          => "ipa",
    "iPhone"        => "iph",
    "iPod"          => "ipo",
    "Linux"         => "lin",
    "Android"       => "and",
    "BlackBerry"    => "rim",
    "webOS"         => "weo",
    "Windows Phone" => "wip"
  }
  def self.browser_and_platform_key(user_agent)
    useragent    = UserAgent.parse(user_agent)
    browser_key  = SUPPORTED_BROWSER[useragent.browser] || "oth"
    platform_key = SUPPORTED_PLATEFORM[useragent.platform] || (useragent.mobile? ? "otm" : "otd")
    browser_key + '-' + platform_key
  end

end
