require 'spec_helper'

describe Application do
  it "responses with CORS headers on OPTIONS" do
    with_api(Application) do |a|
      options_request do |api|
        headers = api.response_header
        headers['Access-Control-Allow-Origin'].should eq('*')
        headers['Access-Control-Allow-Methods'].should eq('POST')
        headers['Access-Control-Allow-Headers'].should eq('Content-Type')
        headers['Access-Control-Allow-Credentials'].should eq('true')
        headers['Access-Control-Max-Age'].should eq('1728000')
      end
    end
  end

  it "responses with CORS headers on POST" do
    with_api(Application) do |a|
      post_request do |api|
        headers = api.response_header
        headers['Access-Control-Allow-Origin'].should eq('*')
      end
    end
  end

  it "parses always in params in JSON" do
    with_api(Application) do |a|
      post_request(body: MultiJson.dump(test: 'ok'), head: { 'Content-Type' => 'text/plain' }) do |api|
        body = MultiJson.load(api.response)
        body.should eq("test" => "ok")
      end
    end
  end
end
