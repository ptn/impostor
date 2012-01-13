require 'data_mapper'
require 'impostor/server'

module Impostor
  base = File.expand_path("~/.impostor")
  DataMapper::Logger.new(File.join(base, 'db.log'), :debug)
  DataMapper.setup(:default, 'sqlite://' + File.join(base,'impostor.db'))
end

require 'impostor/user'
require 'impostor/game'
require 'impostor/player'

DataMapper.finalize
DataMapper.auto_upgrade!
