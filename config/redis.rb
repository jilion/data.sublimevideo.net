config['redis'] = Redis.connect(url: ENV['REDISTOGO_URL'])  # localhost if ENV['REDISTOGO_URL'] isn't present
