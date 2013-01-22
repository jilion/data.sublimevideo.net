require 'redis_wrapper'

class VideoTagCRC32Hash
  attr_reader :site_token, :uid

  def self.get(site_token, uid)
    new(site_token, uid).get
  end

  def self.set(site_token, uid, crc32_hash)
    new(site_token, uid).set(crc32_hash)
  end

  def initialize(site_token, uid)
    @site_token = site_token
    @uid = uid
  end

  def get
    RedisWrapper.connection { |r| r.hget(:video_tag_crc32_hashes, key) }
  end

  def set(crc32_hash)
    RedisWrapper.connection { |r| r.hset(:video_tag_crc32_hashes, key, crc32_hash) }
  end

  private

  def key
    "#{site_token}#{uid}"
  end

end
