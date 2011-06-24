require './app/helpers/time_helper'

class IncrPlayerViewsController < Goliath::API
  include TimeHelper

  def response(env)
    key = today + params[:site_token]
    redis.hincrby key, "p", 1

    [200, { 'Content-Type' => 'text/javascript' }, 'sublimevideo.pInc=true']
  end

end
