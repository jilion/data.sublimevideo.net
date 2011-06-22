class PlayerViewsController < Goliath::API

  def response(env)
    increment_player_views(params[:site_token])

    [200, { 'Content-Type' => 'text/javascript' }, 'sublimevideo.pInc=true']
  end

private

  def increment_player_views(site_token)
    mongo.collection('site_usages_test').update(
      { :site_token => site_token, :day => today },
      { "$inc" => { :player_views => 1 } },
      :upsert => true
    )
  end

  def today
    now = Time.now.utc
    Time.utc(now.year, now.month, now.day)
  end

end
