class HomeAction < Cramp::Action

  def start
    render "Redirect to http://sublimevideo.net!"
    finish
  end

  def respond_with
    [301, { 'Location' => 'http://sublimevideo.net' }]
  end

end
