require "spec_helper"

describe VideoTagDataMD5Hash do
  let(:site_token) { 'abcd1234' }
  let(:video_uid) { 'video_uid' }

  describe ".get / .set" do
    it "returns nil when no MD5 Hash exist" do
      with_api(Application) do
        described_class.get(site_token, video_uid).should be_nil
        EM.stop
      end
    end

    it "returns md5 hash when one is set" do
      with_api(Application) do
        described_class.set(site_token, video_uid, "md5_hash")
        described_class.get(site_token, video_uid).should eq "md5_hash"
        EM.stop
      end
    end
  end
end
