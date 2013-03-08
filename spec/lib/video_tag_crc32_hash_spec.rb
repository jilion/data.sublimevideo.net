require 'fast_spec_helper'

require 'video_tag_crc32_hash'

describe VideoTagCRC32Hash do
  let(:site_token) { 'abcd1234' }
  let(:uid) { 'uid' }
  let(:video_tag_crc32_hash) { VideoTagCRC32Hash.new(site_token, uid) }

  before { $mongo[:video_tag_crc32_hashes].remove }

  describe "#get" do
    it "returns nil when no CRC32 Hash exist" do
      video_tag_crc32_hash.get.should be_nil
    end
  end

  describe "#set" do
    it "sets crc32_hash" do
      video_tag_crc32_hash.set("crc32_hash")
      video_tag_crc32_hash.get.should eq "crc32_hash"
    end
  end
end
