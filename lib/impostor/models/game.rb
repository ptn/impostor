module Impostor
  module Models
    class Game
      include DataMapper::Resource

      property :id, Serial

      has n, :players
      has n, :users, :through => :players

      def interrogator
        players.first(:role => "interrogator").user
      end

      def impersonator
        players.first(:role => "impersonator").user
      end

      def honest
        players.first(:role => "honest").user
      end

      def random_player
        players.all(:role.not => "interrogator").sample.user
      end
    end
  end
end
