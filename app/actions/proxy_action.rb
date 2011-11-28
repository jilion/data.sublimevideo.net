require 'em-http-request'
require 'em-synchrony/em-http'

class ProxyAction < Cramp::Action
  use_fiber_pool

  before_start :get_page

  def start
    render @page.response
    finish
  end

  def respond_with
    header = @page.response_header
    [200, { 'Content-Type' => header['CONTENT_TYPE'], 'Content-Length' => header['CONTENT_LENGTH'] }]
  end

  def get_page
    @page = EventMachine::HttpRequest.new(params[:u]).get
    yield
  end

end
