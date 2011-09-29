require 'spec_helper'

describe StatAction, :cramp => true do

  # You need to define this method
  def app
    StatAction # Here goes your cramp application, action or http routes.
  end

  # Matching on status code.
  it "should respond to a GET request" do
    get("/_.gif").should respond_with :status => 200
    get("/_.gif").should respond_with :headers => { "Content-Type"   => "image/gif" }
    get("/_.gif").should respond_with :headers => { "Content-Length" => "35" }
  end

end
