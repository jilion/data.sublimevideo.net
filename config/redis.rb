config['redis'] = EM::Synchrony::ConnectionPool.new(size: 10) do
  Redis.connect(url: ENV['REDISTOGO_URL'])  # localhost if ENV['REDISTOGO_URL'] isn't present
end
