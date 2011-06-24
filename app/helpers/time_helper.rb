module TimeHelper
  
  def today
    Time.now.utc.strftime('%y%m%d')
  end
  
end