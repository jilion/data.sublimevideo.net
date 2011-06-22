require 'erb'
settings = YAML.load(ERB.new(File.new('./config/mongo.yml').read).result)[Goliath.env.to_s]

require 'em-synchrony/em-mongo'

environment [:development, :test] do
  config['mongo'] = EventMachine::Synchrony::ConnectionPool.new(size: 20) do
    conn = EM::Mongo::Connection.new(settings['host'], 27017, 1, reconnect_in: 1)
    conn.db(settings['database'])
  end
end

environment :production do
  m = settings['uri'].match(/mongodb:\/\/(.*):(.*)@(.*):(\d+)\/(.*)/)
  username, password, host, port, db = m[1], m[2], m[3], m[4], m[5]

  config['mongo'] = EventMachine::Synchrony::ConnectionPool.new(size: 20) do
    conn = EM::Mongo::Connection.new(host, port, 1, reconnect_in: 1)
    conn.db(db).authenticate(username,password)
    conn
  end
end
