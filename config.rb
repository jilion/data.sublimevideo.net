Honeybadger.configure do |config|
  config.api_key = '7586a6c1'

  config.async do |notice|
    Thread.new { notice.deliver }
  end
end
