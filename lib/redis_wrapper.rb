module RedisWrapper

  def self.connection(&block)
    Sidekiq.redis(&block)
  end

end
