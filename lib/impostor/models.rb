require_relative 'models/setup'

require_relative 'models/user'
require_relative 'models/game'
require_relative 'models/question'
require_relative 'models/answer'
require_relative 'models/player'

DataMapper.finalize
DataMapper.auto_upgrade!
