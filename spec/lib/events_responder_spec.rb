require 'spec_helper'

require 'events_responder'

describe EventsResponder do
  let(:metrics_queue) { mock('metrics_queue', add: true) }
  let(:site_token) { 'site_token' }
  let(:uid) { 'uid' }
  let(:request) { double('request', ip: '127.0.0.1', user_agent: 'user_agent') }
  let(:events_responder) { EventsResponder.new(site_token, params, request) }
  let(:video_tag_crc32_hash) { double('VideoTagCRC32Hash') }

  describe "#response" do
    before { VideoTagCRC32Hash.stub(:new).with(site_token, uid) { video_tag_crc32_hash } }

    it "responds only to Array params" do
      responder = EventsResponder.new(site_token, { 'foo' => 'bar' }, request)
      responder.response.should eq []
    end

    context 'app load (al) event' do
      let(:params) { [{ 'e' => 'al', 'ho' => 'm' }] }
      before { StatsHandlerWorker.stub(:perform_async) }

      it "delays stats handling" do
        StatsHandlerWorker.should_receive(:perform_async).with(
          :al,
          { 'ho' => 'm', 's' => site_token, 't' => kind_of(Integer), 'ua' => 'user_agent', 'ip' => '127.0.0.1' }
        )
        events_responder.response
      end

      it "responses nothing" do
        events_responder.response.should eq []
      end

      it "increments Librato metrics" do
        Librato.should_receive(:increment).with("data.events_type", source: "al")
        events_responder.response
      end
    end

    context 'start (s) event' do
      let(:params) { [{ 'e' => 's', 'ex' => '1'}] }
      before { StatsHandlerWorker.stub(:perform_async) }

      it "delays stats handling" do
        StatsHandlerWorker.should_receive(:perform_async).with(
          :s,
          { 'ex' => '1', 's' => site_token, 't' => kind_of(Integer), 'ua' => 'user_agent', 'ip' => '127.0.0.1' }
        )
        events_responder.response
      end

      it "doesn't delays video_tag duration update without u params" do
        expect(VideoTagDurationUpdaterWorker).to_not receive(:perform_async)
        events_responder.response
      end

      context 'with uid and vd data' do
        let(:params) { [{ 'e' => 's', 'u' => uid, 'vd' => '123456'}] }

        it "delays video_tag duration update" do
          expect(VideoTagDurationUpdaterWorker).to receive(:perform_async).with(site_token, uid, '123456')
          events_responder.response
        end
      end

      it "responses nothing" do
        events_responder.response.should eq []
      end

      it "increments Librato metrics" do
        Librato.should_receive(:increment).with("data.events_type", source: "s")
        events_responder.response
      end
    end

    context 'load (l) event' do
      before { StatsHandlerWorker.stub(:perform_async) }

      context "multiple events" do
        let(:params) { [
          { 'e' => 'l', 'u' => uid },
          { 'e' => 'l' ,'u' => 'other_uid' }
        ] }

        it "returns video_tag_crc32_hash" do
          video_tag_crc32_hash.should_receive(:get) { 'crc32_hash' }
          VideoTagCRC32Hash.stub(:new).with(site_token, 'other_uid') { video_tag_crc32_hash }
          video_tag_crc32_hash.should_receive(:get) { nil }

          events_responder.response.should eq [
            { e: 'l', u: "uid", h: "crc32_hash" },
            { e: 'l', u: "other_uid", h: nil }
          ]
        end
      end

      context "with uid" do
        let(:params) { [{ 'e' => 'l', 'u' => uid }] }
        before { video_tag_crc32_hash.stub(:get) }

        it "returns video_tag_crc32_hash" do
          video_tag_crc32_hash.should_receive(:get) { 'crc32_hash' }
          events_responder.response.should eq [{ e: 'l', u: "uid", h: "crc32_hash" }]
        end

        it "delays stats handling" do
          StatsHandlerWorker.should_receive(:perform_async).with(
            :l,
            { 'u' => 'uid', 's' => site_token, 't' => kind_of(Integer), 'ua' => 'user_agent', 'ip' => '127.0.0.1' }
          )
          events_responder.response
        end

        it "increments Librato metrics" do
          Librato.should_receive(:increment).with("data.events_type", source: "l")
          events_responder.response
        end
      end

      context "without uid" do
        let(:params) { [{ 'e' => 'l', 'd' => 'm' }] }

        it "responses nothing" do
          events_responder.response.should eq []
        end

        it "delays stats handling" do
          StatsHandlerWorker.should_receive(:perform_async).with(
            :l,
            { 'd' => 'm', 's' => site_token, 't' => kind_of(Integer), 'ua' => 'user_agent', 'ip' => '127.0.0.1' }
          )
          events_responder.response
        end

        it "increments Librato metrics" do
          Librato.should_receive(:increment).with("data.events_type", source: "l")
          events_responder.response
        end
      end
    end

    context "video tag data (v) event" do
      let(:params) { [{ 'e' => 'v', 'u' => uid, 'h' => 'crc32_hash', 'a' => { "data" => "settings" } }] }
      before {
        video_tag_crc32_hash.stub(:set)
        video_tag_crc32_hash.stub(:get) { 'other_crc32_hash' }
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

      context "video_tag_crc32_hash already set" do
        before { video_tag_crc32_hash.stub(:get) { 'crc32_hash' } }

        it "doesn't set it again" do
          video_tag_crc32_hash.should_not_receive(:set)
          events_responder.response
        end

        it "doesn't delays video_tag update" do
          VideoTagUpdaterWorker.should_not_receive(:perform_async)
          events_responder.response
        end
      end

      it "responses nothing" do
        events_responder.response.should eq []
      end
    end

  end
end
