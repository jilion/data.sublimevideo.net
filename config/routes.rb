# Check out https://github.com/joshbuddy/http_router for more information on HttpRouter
HttpRouter.new do
  add('/').to(HomeAction)
  add('/_.gif').to(StatAction)
  add('/proxy').to(ProxyAction)
end
