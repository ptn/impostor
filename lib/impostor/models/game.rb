module Impostor
  module Models
    class Game
      include DataMapper::Resource

      property :id, Serial

      has n, :players
      has n, :users, :through => :players
    end
  end
end
