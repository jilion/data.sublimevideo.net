class PlayerViewsController < Goliath::API

  def response(env)
    res = redis.incr("p")

    # [200, { 'Content-Type' => 'text/javascript' }, 'sublimevideo.pInc=true']
    [200, { 'Content-Type' => 'text/javascript' }, res]
  end


end
