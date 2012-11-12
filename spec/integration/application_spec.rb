require 'spec_helper'

describe Application do
  it "my" do
    with_api(Application) do |a|
      get_request(path: '/', query: { echo: "foo"}) do |api|
            # puts  MultiJson.load(api.response)
        #     b['response'].should == 'test'
        # puts api
        api.response.should eq "echo:'foo'"
      end
    end
  end
end
