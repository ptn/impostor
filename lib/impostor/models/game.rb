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

      def randomized_players
        rand_players = players.all(:role.not => "interrogator")
        rand_players = rand_players.sort_by { rand }
        rand_players.map { |p| p.user }
      end
    end
  end
end
