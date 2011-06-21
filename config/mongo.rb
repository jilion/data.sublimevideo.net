settings = YAML.load(ERB.new(File.new('./config/mongoid.yml').read).result)
Mongoid.logger = logger

environment [:development, :production] do
  Mongoid.from_hash(settings[Goliath.env.to_s])
  # require 'em-synchrony/mongoid'
end
