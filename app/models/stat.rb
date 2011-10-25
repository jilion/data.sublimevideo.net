class Stat
  include Mongoid::Document

  # DateTime periods
  field :s,  :type => DateTime  # Second

  # =================
  # = Class Methods =
  # =================

  def self.inc_and_push_stats(params, user_agent)
    if %w[m e].include?(params[:h]) && !params.key?(:em)
      incs   = StatRequestParser.stat_incs(params, user_agent)
      second = Time.now.change(usec: 0).to_time
      inc_stats(incs, second)
      push_stats(incs, second)
    end
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
    json = convert_incs_to_json(incs)
    Pusher["presence-#{incs[:site][:t]}"].trigger_async('stats', json.merge(id: second.to_i))
  end
  
  def self.convert_incs_to_json(incs)
    
  end

  # def self.inc_and_json(params, user_agent)
  #   # inc, json = {}, {}
  #   # case params[:e]
  #   # when 'l' # Player load &  Video prepare
  #   #   unless params.key?(:po) # video prepare only
  #   #     inc['pv.' + params[:h]] = 1 # Page Visits
  #   #     inc['bp.' + browser_and_platform_key(user_agent)] = 1 # Browser + Plateform
  #   #     json = { 'pv' => 1, 'bp' => { browser_and_platform_key(user_agent) => 1 } }
  #   #   end
  #   #   # Player Mode + Device hash
  #   #   if params.key?(:pm) && params.key?(:d)
  #   #     json['md'] = { 'h' => {}, 'f' => {} }
  #   #     params[:pm].uniq.each do |pm|
  #   #       inc['md.' + pm + '.' + params[:d]] = params[:pm].count(pm)
  #   #       json['md'][pm] = { params[:d] => params[:pm].count(pm) }
  #   #     end
  #   #   end
  #   # when 's' # Video start (play)
  #   #   # Video Views
  #   #   inc['vv.' + params[:h]] = 1
  #   #   json = { 'vv' => 1 }
  #   # end
  #   # [inc, json]
  # end

end
