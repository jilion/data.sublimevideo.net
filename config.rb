Honeybadger.configure do |config|
  config.api_key = ENV['HONEYBADGER_API_KEY']

  config.async do |notice|
    Thread.new { notice.deliver }
  end

  config.ignore_by_filter do |exception_data|
    puts exception_data.inspect
    false
  end
end
