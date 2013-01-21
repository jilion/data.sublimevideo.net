require 'redis_wrapper'

class VideoTagMD5Hash
  attr_reader :site_token, :uid

  def self.get(site_token, uid)
    new(site_token, uid).get
  end

  def self.set(site_token, uid, md5_hash)
    new(site_token, uid).set(md5_hash)
  end

  def initialize(site_token, uid)
    @site_token = site_token
    @uid = uid
  end

  def get
    RedisWrapper.connection { |r| r.hget(:video_tag_md5_hashes, key) }
  end

  def set(md5_hash)
    RedisWrapper.connection { |r| r.hset(:video_tag_md5_hashes, key, md5_hash) }
  end

  private

  def key
    "#{site_token}#{uid}"
  end

end
