class VideoTagMD5Hash

  def self.get(site_token, uid)
    redis { |r| r.hget(:video_tag_md5_hashes, "#{site_token}#{uid}") }
  end

  def self.set(site_token, uid, md5_hash)
    redis { |r| r.hset(:video_tag_md5_hashes, "#{site_token}#{uid}", md5_hash) }
  end

private

  def self.redis(&block)
    Sidekiq.redis(&block)
  end

end
