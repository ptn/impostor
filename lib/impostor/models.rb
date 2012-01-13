require 'data_mapper'

module Impostor
  module Models
    base = File.expand_path("~/.impostor")
    DataMapper::Logger.new(File.join(base, 'db.log'), :debug)
    DataMapper.setup(:default, 'sqlite://' + File.join(base,'impostor.db'))
  end
end

require 'impostor/models/user'
require 'impostor/models/game'
require 'impostor/models/player'

DataMapper.finalize
DataMapper.auto_upgrade!
