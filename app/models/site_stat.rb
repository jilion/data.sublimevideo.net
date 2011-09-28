class SiteStat
  include Mongoid::Document

  field :t,  :type => String # Site token

  # DateTime periods
  field :s,  :type => DateTime  # Second

  field :pv, :type => Hash # Page Visits: { m (main) => 2, e (extra) => 10, d (dev) => 43, i (invalid) => 2 }
  field :vv, :type => Hash # Video Views: { m (main) => 1, e (extra) => 3, d (dev) => 11, i (invalid) => 1 }
  field :md, :type => Hash # Player Mode + Device hash { h (html5) => { d (desktop) => 2, m (mobile) => 1 }, f (flash) => ... }
  field :bp, :type => Hash # Browser + Plateform hash { "saf-win" => 2, "saf-osx" => 4, ...}

  # ================
  # = Associations =
  # ================

  # ==========
  # = Scopes =
  # ==========

  %w[s m h d].each do |period|
    scope "#{period}_after".to_sym, lambda { |date| where(period => { "$gte" => date.to_i }).order_by([period.to_sym, :asc]) }
    scope "#{period}_before".to_sym,  lambda { |date| where(period => { "$lt" => date.to_i }).order_by([period.to_sym, :asc]) }
    scope "#{period}_between".to_sym, lambda { |start_date, end_date| where(period => { "$gte" => start_date.to_i, "$lt" => end_date.to_i }).order_by([period.to_sym, :asc]) }
  end

  # ====================
  # = Instance Methods =
  # ====================

  # time for backbonejs model
  def t
    s.to_i
  end

  # only main & extra hostname are counted in charts
  def pv
    pv = read_attribute(:pv)
    pv['m'].to_i + pv['e'].to_i
  end
  def vv
    vv = read_attribute(:vv)
    vv['m'].to_i + vv['e'].to_i
  end

  # =================
  # = Class Methods =
  # =================

  # def self.json(token, period_type = 'days')
  #   json_stats.to_json(except: [:_id, :t, :s, :m, :h, :d], methods: [:t])
  # end

  def self.inc_second_stats(params, user_agent)
    second = Time.now.change(usec: 0).to_time
    inc = incs_from_params_and_user_agent(params, user_agent)
    self.collection.update({ t: params[:t], s: second }, { "$inc" => inc }, upsert: true)
  end

private

  def self.incs_from_params_and_user_agent(params, user_agent)
    incs = {}
    if params.key?(:e) && params.key?(:h)
      case params[:e]
      when 'l' # Player load
        # Page Visits
        incs['pv.' + params[:h]] = 1
        # Browser + Plateform
        if %w[m e].include?(params[:h])
          incs['bp.' + browser_and_platform_key(user_agent)] = 1
        end
      when 'p' # Video prepare
        # Player Mode + Device hash
        if %w[m e].include?(params[:h]) && params.key?(:pm) && params.key?(:pd)
          params[:pm].uniq.each do |pm|
            incs['md.' + pm + '.' + params[:pd]] = params[:pm].count(pm)
          end
        end
      when 's' # Video start (play)
        # Video Views
        incs['vv.' + params[:h]] = 1
      end
    end
    incs
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
