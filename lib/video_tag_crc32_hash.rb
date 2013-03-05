class VideoTagCRC32Hash
  attr_reader :env, :site_token, :uid

  def initialize(env, site_token, uid)
    @env        = env
    @site_token = site_token
    @uid        = uid
  end

  def get
    object = mongo_collection.find({ k: key }).first
    object && object['h']
  end

  def set(crc32_hash)
    document = { k: key }
    mongo_collection.find(document).upsert(document.merge(h: crc32_hash, t: Time.now.utc))
  end

  private

  def key
    "#{site_token}#{uid}"
  end

  def mongo_collection
    env.moped[:video_tag_crc32_hashes]
  end
end
