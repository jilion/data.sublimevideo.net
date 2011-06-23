# class SiteUsage
#   include Mongoid::Document
#   store_in :site_usages_test
#
#   field :site_token
#   field :day,             :type => Time
#
#   field :player_views,    :type => Integer, :default => 0
#   field :video_views,     :type => Integer, :default => 0
#
#   def self.increment(site_token, field)
#     self.collection.update(
#       { :site_token => site_token, :day => today },
#       { "$inc" => { field => 1 } },
#       :upsert => true
#     )
#   end
#
# private
#
#   def self.today
#     now = Time.now.utc
#     Time.utc(now.year, now.month, now.day)
#   end
#
# end
