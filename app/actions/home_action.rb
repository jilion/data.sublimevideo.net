class HomeAction < Cramp::Action
  def start
    SiteStat.create(:s => Time.now.utc.to_time)
    # render SiteStat.all.to_json(except: [:_id, :t, :s, :m, :h, :d], methods: [:t])
    render SiteStat.count
    finish
  end
end
