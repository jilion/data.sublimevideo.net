worker_processes Integer(ENV['WEB_CONCURRENCY'] || 5)
timeout Integer(3)
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  Sidekiq.configure_client do |config|
    config.redis = { size: 1 } # for web dyno
  end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  Sidekiq.configure_client do |config|
    config.redis = { size: 1 } # for web dyno
  end
end
