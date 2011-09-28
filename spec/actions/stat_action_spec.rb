require 'spec_helper'

describe StatAction, :cramp => true do

  # You need to define this method
  def app
    DataSublimeVideo::Application.initialize!
    StatAction # Here goes your cramp application, action or http routes.
  end

  # Matching on status code.
  it "should respond to a GET request" do
    get("/stat").should respond_with :status => 200
  end

end
