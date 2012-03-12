class Stat::Video::Second
  include Mongoid::Document
  include Stat
  store_in :video_second_stats
end
