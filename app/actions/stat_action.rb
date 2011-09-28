class StatAction < Cramp::Action

  def start
    SiteStat.inc_second_stats(params, request.env["HTTP_USER_AGENT"])
    finish
  end

  def respond_with
    [200, {'Content-Type' => 'text/html'}]
  end

end
