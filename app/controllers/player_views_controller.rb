class PlayerViewsController < Goliath::API

  def response(env)
    SiteUsage.increment(params[:site_token], :player_views)

    [200, { 'Content-Type' => 'text/javascript' }, 'sublimevideo.pInc=true']
  end


end
