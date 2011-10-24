require 'spec_helper'

describe HomeAction, :cramp => true do

  # You need to define this method
  def app
    HomeAction # Here goes your cramp application, action or http routes.
  end

  # Matching on status code.
  it "should respond to a GET request" do
    get("/").should respond_with :status => 301
    get("/").headers["Location"].should eql 'http://sublimevideo.net'
    # get("/").should respond_with :body => "I'm a super stats async server :)"
  end

end
