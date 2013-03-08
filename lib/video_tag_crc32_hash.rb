class VideoTagCRC32Hash
  attr_reader :site_token, :uid

  def initialize(site_token, uid)
    @site_token = site_token
    @uid        = uid
  end

  def get
    object = mongo_collection.find(k: key).first
    object && object['h']
  end

  def set(crc32_hash)
    document = { k: key }
    mongo_collection.update({ k: key }, { :$set => { h: crc32_hash, t: Time.now.utc } }, upsert: true)
  end

  private

  def key
    "#{site_token}#{uid}"
  end

  def mongo_collection
    $mongo[:video_tag_crc32_hashes]
  end
end
