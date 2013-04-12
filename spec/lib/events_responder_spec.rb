require 'spec_helper'

require 'events_responder'

describe EventsResponder do
  let(:metrics_queue) { mock('metrics_queue', add: true) }
  let(:site_token) { 'site_token' }
  let(:uid) { 'uid' }
  let(:events_responder) { EventsResponder.new(site_token, params) }
  let(:video_tag_crc32_hash) { mock(VideoTagCRC32Hash) }

  describe "#response" do
    before { VideoTagCRC32Hash.stub(:new).with(site_token, uid) { video_tag_crc32_hash } }

    it "responds only to Array params" do
      responder = EventsResponder.new(site_token, { 'foo' => 'bar' })
      responder.response.should eq []
    end

    context "with one h event" do
      let(:params) { [{ 'h' => { 'u' => uid } }] }
      before { video_tag_crc32_hash.stub(:get) }

      it "returns video_tag_crc32_hash" do
        video_tag_crc32_hash.should_receive(:get) { 'crc32_hash' }
        events_responder.response.should eq [{ h: { u: "uid", h: "crc32_hash" } }]
      end

      it "increments Librato metrics" do
        Librato.should_receive(:increment).with("data.events_type", source: "h")
        events_responder.response
      end
    end

    context "with multiple h events" do
      let(:params) { [
        { 'h' => { 'u' => uid } },
        { 'h' => { 'u' => 'other_uid' } }
      ] }

      it "returns video_tag_crc32_hash" do
        video_tag_crc32_hash.should_receive(:get) { 'crc32_hash' }
        VideoTagCRC32Hash.stub(:new).with(site_token, 'other_uid') { video_tag_crc32_hash }
        video_tag_crc32_hash.should_receive(:get) { nil }

        events_responder.response.should eq [
          { h: { u: "uid", h: "crc32_hash" } },
          { h: { u: "other_uid", h: nil } }
        ]
      end
    end

    context "with one v event" do
      let(:params) { [{ 'v' => { 'u' => uid, 'h' => 'crc32_hash', 'a' => { "data" => "settings" } } }] }

      before {
        video_tag_crc32_hash.stub(:set)
        VideoTagUpdaterWorker.stub(:perform_async)
      }

      it "sets video_tag_crc32_hash" do
        video_tag_crc32_hash.should_receive(:set).with('crc32_hash')
        events_responder.response
      end

      it "delays video_tag update" do
        VideoTagUpdaterWorker.should_receive(:perform_async).with(
          site_token,
          uid,
          { "a" => { "data" => "settings" } })
        events_responder.response
      end

      it "responses nothing" do
        events_responder.response.should eq []
      end
    end
  end
end
