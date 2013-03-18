class VideoTagCRC32Hash
  REDIS_HASH = :video_tag_crc32_hashes
  attr_reader :site_token, :uid

  def initialize(site_token, uid)
    @site_token = site_token
    @uid        = uid
  end

  def get
    value = Sidekiq.redis { |con| con.hget(REDIS_HASH, key) }
    time, hash = value && value.split(':')
    return hash if time.to_i > (Time.now.to_i - 60*60*24)
  rescue; nil
  end

  def set(crc32_hash)
    Sidekiq.redis { |con| con.hset(REDIS_HASH, key, "#{Time.now.to_i}:#{crc32_hash}") }
  rescue; nil
  end

  private

  def key
    "#{site_token}#{uid}"
  end
end
