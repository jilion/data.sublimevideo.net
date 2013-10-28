web: bundle exec unicorn -p $PORT -E $RACK_ENV -c ./unicorn.rb
scheduler: bundle exec rake scheduler:scale_dynos
