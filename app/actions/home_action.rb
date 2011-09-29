class HomeAction < Cramp::Action
  use_fiber_pool

  def start
    render "I'm a super stats async server :)"
    finish
  end

end
