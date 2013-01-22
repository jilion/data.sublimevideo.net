require "fast_spec_helper"

require 'sidekiq'
require 'sidekiq/testing'

require File.expand_path('lib/redis_wrapper')
require File.expand_path('lib/video_tag_crc32_hash')

describe VideoTagCRC32Hash do
  let(:site_token) { 'abcd1234' }
  let(:uid) { 'uid' }
  let(:video_tag_crc32_hash) { VideoTagCRC32Hash.new(site_token, uid) }
  before {
    Sidekiq.configure_client do |config|
      config.redis = { driver: 'ruby' }
    end
    RedisWrapper.connection { |r| r.flushall }
  }

  describe "#get" do
    it "returns nil when no CRC32 Hash exist" do
      video_tag_crc32_hash.get.should be_nil
    end
  end

  describe "#set" do
    it "returns crc32 hash when one is set" do
      video_tag_crc32_hash.set("crc32_hash")
      video_tag_crc32_hash.get.should eq "crc32_hash"
    end
  end
end
