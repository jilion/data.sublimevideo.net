class VideoTagDataMD5Hash

  def self.get(site_token, video_uid)
    redis { |r| r.hget(:video_tag_data_md5_hashes, "#{site_token}#{video_uid}") }
  end

  def self.set(site_token, video_uid, md5_hash)
    redis { |r| r.hset(:video_tag_data_md5_hashes, "#{site_token}#{video_uid}", md5_hash) }
  end

private

  def self.redis(&block)
    Sidekiq.redis(&block)
  end

end
