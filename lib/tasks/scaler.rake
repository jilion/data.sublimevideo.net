require 'newrelic_api'
class NewRelicWrapper
  def initialize(app_id)
    NewRelicApi.api_key = ENV['NEW_RELIC_API_KEY']
    @app_id = app_id
  end

  def throughput
    application.threshold_values.detect { |a| a.name == 'Throughput' }.metric_value
  end

  def application
    account.applications.detect { |a| a.id = @app_id.to_s }
  end

  def account
    NewRelicApi::Account.find(:first)
  end
end

require 'heroku-api'
class HerokuWrapper
  def initialize(app)
    @client = Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
    @app = app
  end

  def ps_n(type)
    @client.get_ps(@app).body.count {|ps| ps['process'].match /#{type}\.\d?/ }
  end

  def ps_scale(type, n)
    return if n == ps_n(type)

    @client.post_ps_scale(@app, type , n)
    puts "Scale #{@app} #{type} dynos to #{n}."
  end
end

def dynos_required
  new_relic = NewRelicWrapper.new(1898958) # data2.sv.app
  rpm = new_relic.throughput
  (rpm / 2000.0).ceil
end

namespace :scheduler do
  desc "Shift and create logs"
  task :scale_dynos do
    dynos = dynos_required

    data  = HerokuWrapper.new('sv-data2')
    data.ps_scale(:web, [dynos, 2].max)
  end
end
