require 'spec_helper'

describe Application do
  it "responses with CORS headers on OPTIONS" do
    # with_api(Application) do |a|
    #   get_request(path: '/', query: { echo: "foo"}) do |api|
    #     body = MultiJson.load(api.response)
    #     body.should eq("echo" => "foo")
    #   end
    # end
    with_api(Application) do |a|
      options_request do |api|
        headers = api.response_header
        headers['Access-Control-Allow-Origin'].should eq('*')
        headers['Access-Control-Allow-Methods'].should eq('POST')
        headers['Access-Control-Allow-Headers'].should eq('Content-Type')
        headers['Access-Control-Allow-Credentials'].should eq('true')
        headers['Access-Control-Max-Age'].should eq('5')
        # body = MultiJson.load(api.response)
        # body.should eq("echo" => "foo")
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
end
