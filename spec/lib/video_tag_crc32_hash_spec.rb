require 'spec_helper'
require 'timecop'

require 'video_tag_crc32_hash'

describe VideoTagCRC32Hash do
  let(:site_token) { 'abcd1234' }
  let(:uid) { 'uid' }
  let(:video_tag_crc32_hash) { VideoTagCRC32Hash.new(site_token, uid) }

  describe "#get" do
    it "returns crc32 hash when set in the last 24h" do
      video_tag_crc32_hash.set("crc32_hash")
      video_tag_crc32_hash.get.should eq "crc32_hash"
    end

    it "returns nil when crc32 hash wasn't set in the last 24h" do
      Timecop.travel(-60*60*24) do
        video_tag_crc32_hash.set("crc32_hash")
      end
      video_tag_crc32_hash.get.should be_nil
    end

    it "returns nil when no crc32 Hash exist" do
      video_tag_crc32_hash.get.should be_nil
    end
  end

  describe "#set" do
    it "sets crc32_hash with timestamp" do
      Timecop.freeze do
        time = Time.now.to_i
        video_tag_crc32_hash.set("crc32_hash")
        Sidekiq.redis { |con| con.hget(VideoTagCRC32Hash::REDIS_HASH, 'abcd1234uid') }.should eq "#{time.to_i}:crc32_hash"
      end
    end
  end
end
