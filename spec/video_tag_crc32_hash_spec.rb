require 'fast_spec_helper'

require 'video_tag_crc32_hash'

describe VideoTagCRC32Hash do
  let(:site_token) { 'abcd1234' }
  let(:uid) { 'uid' }
  let(:collection) { mock('collection') }
  let(:moped) { mock('moped', :[] => collection) }
  let(:env) { mock('env', moped: moped )}
  let(:video_tag_crc32_hash) { VideoTagCRC32Hash.new(env, site_token, uid) }

  describe "#get" do
    it "returns nil when no CRC32 Hash exist" do
      collection.stub_chain(:find, :first) { nil }
      video_tag_crc32_hash.get.should be_nil
    end

    it "returns crc32 hash when exist" do
      collection.stub_chain(:find, :first) { {'h' => 'crc32_hash'} }
      video_tag_crc32_hash.get.should eq 'crc32_hash'
    end
  end

  describe "#set" do
    it "sets crc32_hash" do
      collection.should_receive(:insert).with(k: "#{site_token}#{uid}", h: "crc32_hash", t: kind_of(Time))
      video_tag_crc32_hash.set("crc32_hash")
    end
  end
end
