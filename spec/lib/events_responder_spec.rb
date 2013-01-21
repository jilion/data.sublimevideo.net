require "fast_spec_helper"

require File.expand_path('lib/events_responder')

describe EventsResponder do
  let(:site_token) { 'site_token' }
  let(:uid) { 'uid' }
  let(:events_responder) { EventsResponder.new(site_token, params) }

  describe "#response" do

    it "responds only to Array params" do
      responder = EventsResponder.new(site_token, { 'foo' => 'bar' })
      responder.response.should eq []
    end

    context "one h event" do
      let(:params) { [{ 'e' => 'h', 'u' => uid }] }

      it "returns video_tag_md5_hash" do
        VideoTagMD5Hash.should_receive(:get).with(site_token, uid) { 'md5_hash' }
        events_responder.response.should eq [{ h: { "uid" => "md5_hash" } }]
      end
    end

    context "multiple h events" do
      let(:params) { [
        { 'e' => 'h', 'u' => uid },
        { 'e' => 'h', 'u' => 'other_uid' }
      ] }

      it "returns video_tag_md5_hash" do
        VideoTagMD5Hash.should_receive(:get).with(site_token, uid) { 'md5_hash' }
        VideoTagMD5Hash.should_receive(:get).with(site_token, 'other_uid') { nil }
        events_responder.response.should eq [
          { h: { "uid" => "md5_hash" } },
          { h: { "other_uid" =>  nil } }
        ]
      end
    end

    context "one v event" do
      let(:params) { [{ 'e' => 'v', 'u' => uid, 'h' => 'md5_hash', 'uo' => 'a', 't' => { "data" => "settings" } }] }

      before {
        VideoTagMD5Hash.stub(:set)
        VideoTagUpdaterWorker.stub(:perform_async)
      }

      it "sets video_tag_md5_hash" do
        VideoTagMD5Hash.should_receive(:set).with(site_token, uid, 'md5_hash')
        events_responder.response
      end

      it "delays video_tag update" do
        VideoTagUpdaterWorker.should_receive(:perform_async).with(
          site_token,
          uid,
          { "uo" => "a", "t" => { "data" => "settings" } })
        events_responder.response
      end

      it "responses nothing" do
        events_responder.response.should eq []
      end
    end
  end



end
