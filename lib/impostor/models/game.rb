module Impostor
  class Game
    include DataMapper::Resource

    property :id,       Serial
    property :finished, Boolean, :default => false
    property :guess,    String
    property :won,      Boolean, :default => false

    has n, :players
    has n, :users, :through => :players
    has n, :questions

    def self.start(interrogator)
      game = self.create
      Player.create(:game => game, :user => interrogator, :role => "interrogator")

      impostor, honest = User.pick_for_new_game :exclude => interrogator
      impostor_alias, honest_alias = ["A", "B"].sort_by { rand }

      Player.create(
        :game => game,
        :user_id => impostor.id,
        :role => "impostor",
        :alias => impostor_alias
      )
      Player.create(
        :game => game,
        :user_id => honest.id,
        :role => "honest",
        :alias => honest_alias
      )

      game
    end

    def take_guess(guessed_impersonator_username)
      self.finished = true
      self.guess    = guessed_impersonator_username
      self.won      = (self.guess == impostor.username)
      self.save

      self.won
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

    def player_a
      players.first(:alias => "A")
    end

    def player_b
      players.first(:alias => "B")
    end

    def current_question
      questions.first(:answered => false)
    end
  end
end
