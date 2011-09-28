class HomeAction < Cramp::Action

  def start
    render "I'm a super stats async server :)"
    finish
  end

end
