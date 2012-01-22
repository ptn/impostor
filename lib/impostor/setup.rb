require 'data_mapper'

module Impostor
  base = File.expand_path("~/.impostor")
  DataMapper::Logger.new(File.join(base, 'db.log'), :debug)
  DataMapper.setup(:default, 'sqlite://' + File.join(base,'impostor.db'))
end


require_relative 'user'
require_relative 'game'
require_relative 'question'
require_relative 'answer'
require_relative 'player'

DataMapper.finalize
DataMapper.auto_upgrade!
