class Stat::Site
  include Mongoid::Document
  include Stat
  store_in :site_stats

  field :t,  :type => String # Site token

  field :pv, :type => Hash # Page Visits: { m (main) => 2, e (extra) => 10, d (dev) => 43, i (invalid) => 2 }
  field :vv, :type => Hash # Video Views: { m (main) => 1, e (extra) => 3, d (dev) => 11, i (invalid) => 1 }
  field :md, :type => Hash # Player Mode + Device hash { h (html5) => { d (desktop) => 2, m (mobile) => 1 }, f (flash) => ... }
  field :bp, :type => Hash # Browser + Plateform hash { "saf-win" => 2, "saf-osx" => 4, ...}

end
