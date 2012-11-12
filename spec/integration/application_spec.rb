require 'spec_helper'

describe Application do
  it "responses json" do
    with_api(Application) do |a|
      get_request(path: '/', query: { echo: "foo"}) do |api|
        body = MultiJson.load(api.response)
        body.should eq('status' => 'ok')
      end
    end
  end
end
