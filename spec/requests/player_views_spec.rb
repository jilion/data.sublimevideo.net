require 'spec_helper'

describe PlayerViewsController do
  let(:err) { Proc.new { fail "API request failed" } }
  let(:today) { Date.today.to_datetime.to_time.utc }

  describe ":site_token validation" do
    it "fails with bad :site_token" do
      with_api(App) do
        get_request({:path => '/p/not_a_site_token'}, err) do |cb|
          cb.response_header.status.should == 404
        end
      end
    end

    it "success with good :site_token" do
      with_api(App) do
        get_request({:path => '/p/12345678'}, err) do |cb|
          cb.response_header.status.should == 200
        end
      end
    end
  end

  it "increments SiteUsage player_views" do
    require 'erb'
    require 'em-synchrony/em-mongo'
    settings = YAML.load(ERB.new(File.new('./config/mongo.yml').read).result)['test']

    EM.synchrony do
      collection = EM::Mongo::Connection.new(settings['host'], 27017, 1, reconnect_in: 1).db(settings['database']).collection('site_usages')
      collection.remove({})
      collection.first({}).should be_nil
      EM.stop
    end

    with_api(App) do
      get_request({:path => '/p/12345678'}, err) do |cb|
        cb.response_header.status.should == 200
        cb.response.should == 'sublimevideo.pInc=true'
      end
    end

    EM.synchrony do
      collection = EM::Mongo::Connection.new(settings['host'], 27017, 1, reconnect_in: 1).db(settings['database']).collection('site_usages')
      collection.first({})['player_views'].should == 1
      EM.stop
    end
  end

end