Honeybadger.configure do |config|
  config.api_key = ENV['HONEYBADGER_API_KEY']

  config.async do |notice|
    Thread.new { notice.deliver }
  end

  config.ignore_by_filter do |exception_data|
    player_version = exception_data[:parameters]['v']
    [nil, '2.5.28', '2.5.29', '2.5.30'].include?(player_version)
  end
end
