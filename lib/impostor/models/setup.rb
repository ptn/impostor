require 'data_mapper'

module Impostor
  DataMapper::Logger.new(DbConfiguration::LOG_FILE, :debug)
  DataMapper.setup(:default, DbConfiguration::DB_URL)
end
