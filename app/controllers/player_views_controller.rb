class PlayerViewsController < Goliath::API

  def response(env)
    SiteUsage.increment(params[:site_token], :player_views)

    [200, { 'Content-Type' => 'application/javascript' }, status: 'ok']
  end

end
