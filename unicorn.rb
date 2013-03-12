worker_processes 10
timeout 10

require 'sidekiq'
after_fork do |server, worker|
  Sidekiq.configure_client do |config|
    config.redis = { size: 1 }
  end
end
