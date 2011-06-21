class PlayerViewsController < Goliath::API

  def response(env)
    EM.synchrony do
      SiteUsage.increment(params[:site_token], :player_views)
    end

    [200, { 'Content-Type' => 'text/javascript' }, 'sublimevideo.pInc=true']
  end

end
