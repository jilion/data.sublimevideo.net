require 'spec_helper'

require 'events_responder'

describe EventsResponder do
  let(:metrics_queue) { mock('metrics_queue', add: true) }
  let(:site_token) { 'site_token' }
  let(:events) { [] }
  let(:uid) { 'uid' }
  let(:request) { double('request', ip: '127.0.0.1', user_agent: 'user_agent', params: {}) }
  let(:env) { { 'data.site_token' => site_token, 'data.events' => events } }
  let(:events_responder) { EventsResponder.new(env) }
  let(:video_tag_crc32_hash) { double('VideoTagCRC32Hash') }

  before {
    Librato.stub(:increment)
    Rack::Request.stub(:new) { request }
  }

  describe "#response" do
    before { VideoTagCRC32Hash.stub(:new).with(site_token, uid) { video_tag_crc32_hash } }

    it "responds only to array of events" do
      expect(Honeybadger).to receive(:notify_or_ignore)
      responder = EventsResponder.new(env.merge('data.events' => 'bar'))
      expect(responder.response).to eq []
    end

    context 'app load (al) event' do
      let(:events) { [{ 'e' => 'al', 'ho' => 'm' }] }
      before {
        StatsWithAddonHandlerWorker.stub(:perform_async)
        StatsWithoutAddonHandlerWorker.stub(:perform_async)
      }

      context "with stats addon" do
        before { events.first['sa'] = '1' }

        it "delays stats with addon handling" do
          expect(StatsWithAddonHandlerWorker).to receive(:perform_async).with(
            :al,
            { 'ho' => 'm', 'sa' => '1', 's' => site_token, 't' => kind_of(Integer), 'ua' => 'user_agent', 'ip' => '127.0.0.1' }
          )
          events_responder.response
        end
      end

      context "without stats addon" do
        it "delays stats with addon handling" do
          expect(StatsWithoutAddonHandlerWorker).to receive(:perform_async).with(
            :al,
            { 'ho' => 'm', 's' => site_token, 't' => kind_of(Integer), 'ua' => 'user_agent', 'ip' => '127.0.0.1' }
          )
          events_responder.response
        end
      end

      it "responses nothing" do
        expect(events_responder.response).to eq []
      end

      it "increments Librato metrics" do
        expect(Librato).to receive(:increment).with("data.events_type", source: "al")
        events_responder.response
      end

      it "increments player_version Librato metrics" do
        request.stub(:params) { { 'v' => '3.2.1' } }
        expect(Librato).to receive(:increment).with('data.player_version', source: '3.2.1')
        events_responder.response
      end
    end

    context 'start (s) event' do
      let(:events) { [{ 'e' => 's', 'ex' => '1'}] }
      before {
        StatsWithAddonHandlerWorker.stub(:perform_async)
        StatsWithoutAddonHandlerWorker.stub(:perform_async)
      }

      context "with stats addon" do
        before { events.first['sa'] = '1' }

        it "delays stats with addon handling" do
          expect(StatsWithAddonHandlerWorker).to receive(:perform_async).with(
          :s,
            { 'ex' => '1', 'sa' => '1', 's' => site_token, 't' => kind_of(Integer), 'ua' => 'user_agent', 'ip' => '127.0.0.1' }
          )
          events_responder.response
        end
      end

      context "without stats addon" do
        it "delays stats with addon handling" do
          expect(StatsWithoutAddonHandlerWorker).to receive(:perform_async).with(
            :s,
            { 'ex' => '1', 's' => site_token, 't' => kind_of(Integer), 'ua' => 'user_agent', 'ip' => '127.0.0.1' }
          )
          events_responder.response
        end
      end

      it "doesn't delays video_tag start handler without u params" do
        expect(VideoTagStartHandlerWorker).to_not receive(:perform_async)
        events_responder.response
      end

      context 'with uid and vd data' do
        let(:events) { [{ 'e' => 's', 'u' => uid, 'vd' => '123456'}] }

        it "delays video_tag start handling" do
          expect(VideoTagStartHandlerWorker).to receive(:perform_async).with(site_token, uid, {
            t: kind_of(Time), vd: '123456'
          })
          events_responder.response
        end
      end

      it "responses nothing" do
        expect(events_responder.response).to eq []
      end

      it "increments Librato metrics" do
        expect(Librato).to receive(:increment).with("data.events_type", source: "s")
        events_responder.response
      end

      it "increments player_version Librato metrics" do
        expect(Librato).to receive(:increment).with('data.player_version', source: 'none')
        events_responder.response
      end
    end

    context 'load (l) event' do
      before {
        StatsWithAddonHandlerWorker.stub(:perform_async)
        StatsWithoutAddonHandlerWorker.stub(:perform_async)
      }

      context "multiple events" do
        let(:events) { [
          { 'e' => 'l', 'u' => uid },
          { 'e' => 'l' ,'u' => 'other_uid' }
        ] }

        it "returns video_tag_crc32_hash" do
          expect(video_tag_crc32_hash).to receive(:get) { 'crc32_hash' }
          VideoTagCRC32Hash.stub(:new).with(site_token, 'other_uid') { video_tag_crc32_hash }
          expect(video_tag_crc32_hash).to receive(:get) { nil }

          expect(events_responder.response).to eq [
            { e: 'l', u: "uid", h: "crc32_hash" },
            { e: 'l', u: "other_uid", h: nil }
          ]
        end
      end

      context "with uid" do
        let(:events) { [{ 'e' => 'l', 'u' => uid }] }
        before { video_tag_crc32_hash.stub(:get) }

        it "returns video_tag_crc32_hash" do
          expect(video_tag_crc32_hash).to receive(:get) { 'crc32_hash' }
          expect(events_responder.response).to eq [{ e: 'l', u: "uid", h: "crc32_hash" }]
        end

        context "with stats addon" do
          before { events.first['sa'] = '1' }

          it "delays stats with addon handling" do
            expect(StatsWithAddonHandlerWorker).to receive(:perform_async).with(
              :l,
              { 'sa' => '1', 'u' => 'uid', 's' => site_token, 't' => kind_of(Integer), 'ua' => 'user_agent', 'ip' => '127.0.0.1' }
            )
            events_responder.response
          end
        end

        context "without stats addon" do
          it "delays stats with addon handling" do
            expect(StatsWithoutAddonHandlerWorker).to receive(:perform_async).with(
              :l,
              { 'u' => 'uid', 's' => site_token, 't' => kind_of(Integer), 'ua' => 'user_agent', 'ip' => '127.0.0.1' }
            )
            events_responder.response
          end
        end

        it "increments Librato metrics" do
          expect(Librato).to receive(:increment).with("data.events_type", source: "l")
          events_responder.response
        end
      end

      context "without uid" do
        let(:events) { [{ 'e' => 'l', 'd' => 'm' }] }

        it "responses nothing" do
          expect(events_responder.response).to eq []
        end

        it "delays stats handling" do
          expect(StatsWithoutAddonHandlerWorker).to receive(:perform_async).with(
            :l,
            { 'd' => 'm', 's' => site_token, 't' => kind_of(Integer), 'ua' => 'user_agent', 'ip' => '127.0.0.1' }
          )
          events_responder.response
        end

        it "increments Librato metrics" do
          expect(Librato).to receive(:increment).with("data.events_type", source: "l")
          events_responder.response
        end
      end
    end

    context "video tag data (v) event" do
      let(:events) { [{ 'e' => 'v', 'u' => uid, 'h' => 'crc32_hash', 'a' => { "data" => "settings" } }] }
      before {
        video_tag_crc32_hash.stub(:set)
        video_tag_crc32_hash.stub(:get) { 'other_crc32_hash' }
        VideoTagUpdaterWorker.stub(:perform_async)
      }

      it "sets video_tag_crc32_hash" do
        expect(video_tag_crc32_hash).to receive(:set).with('crc32_hash')
        events_responder.response
      end

      it "delays video_tag update" do
        expect(VideoTagUpdaterWorker).to receive(:perform_async).with(
          site_token,
          uid,
          { "a" => { "data" => "settings" } })
        events_responder.response
      end

      context "video_tag_crc32_hash already set" do
        before { video_tag_crc32_hash.stub(:get) { 'crc32_hash' } }

        it "doesn't set it again" do
          expect(video_tag_crc32_hash).to_not receive(:set)
          events_responder.response
        end

        it "doesn't delays video_tag update" do
          expect(VideoTagUpdaterWorker).to_not receive(:perform_async)
          events_responder.response
        end
      end

      it "responses nothing" do
        expect(events_responder.response).to eq []
      end
    end

  end
end
