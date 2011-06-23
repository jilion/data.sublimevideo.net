environment :development do
  config['redis'] = Redis.new
end

environment :production do
  config['redis'] = Redis.new(url: ENV['REDISTOGO_URL'])
end