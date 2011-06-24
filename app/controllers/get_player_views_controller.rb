require './app/helpers/time_helper'

class GetPlayerViewsController < Goliath::API
  include TimeHelper

  def response(env)
    key = today + params[:site_token]
    res = redis.hget key, "p"

    [200, { 'Content-Type' => 'text/javascript' }, res]
  end

end
