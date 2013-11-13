class StatAction < Cramp::Action
  use_fiber_pool

  def start
    # Stat.inc_and_push_stats(params, request.env["HTTP_USER_AGENT"])
    # render transparent gif
    render "GIF89a\u0001\u0000\u0001\u0000\x80\xFF\u0000\xFF\xFF\xFF\u0000\u0000\u0000,\u0000\u0000\u0000\u0000\u0001\u0000\u0001\u0000\u0000\u0002\u0002D\u0001\u0000;"
    finish
  end

  def respond_with
    [200, { 'Content-Type' => 'image/gif', 'Content-Length' => '35' }]
  end

end
