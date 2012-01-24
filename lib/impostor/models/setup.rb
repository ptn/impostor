require 'data_mapper'

module Impostor
  base = File.expand_path("~/.impostor")
  DataMapper::Logger.new(File.join(base, 'db.log'), :debug)
  DataMapper.setup(:default, 'sqlite://' + File.join(base,'impostor.db'))
end
