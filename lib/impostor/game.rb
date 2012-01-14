module Impostor
  class Game
    include DataMapper::Resource

    property :id, Serial

    has n, :players
    has n, :users, :through => :players
    has n, :questions

    def self.start(interrogator)
      game = self.create
      impostor, honest = User.pick_for_new_game :exclude => interrogator
      Player.create(:game => game, :user => interrogator, :role => "interrogator")
      Player.create(:game => game, :user_id => impostor.id, :role => "impostor")
      Player.create(:game => game, :user_id => honest.id, :role => "honest")
      game
    end

    def interrogator
      players.first(:role => "interrogator").user
    end

    def impostor
      players.first(:role => "impostor").user
    end

    def honest
      players.first(:role => "honest").user
    end

    def randomized_players_as_users
      rand_players = players.all(:role.not => "interrogator")
      rand_players = rand_players.sort_by { rand }
      rand_players.map { |p| p.user }
    end

    def current_question
      questions.first(:answered => false)
    end
  end
end
