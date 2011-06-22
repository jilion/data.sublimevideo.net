settings = YAML.load(ERB.new(File.new('./config/mongo.yml').read).result)[Goliath.env.to_s]

# environment [:development, :production] do
  # Mongoid.logger = logger
  # Mongoid.from_hash(settings)
  # end

  # config['mongo'] = EM::Synchrony::ConnectionPool.new(size: 1) do
    Mongo::Connection.new 'localhost', 27017, :connect => true
    # Mongoid.from_hash(settings)
  # end


# end