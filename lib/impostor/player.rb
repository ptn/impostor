module Impostor
  # The property :alias is the mask with which the game presents the players to
  # the interrogator - in every game, either the impostor or the honest player
  # will be player A and the other one will be player B. Essentially, the game
  # consists of discovering the player
  # behind the alias.
  class Player
    include DataMapper::Resource

    property :id,    Serial
    property :role,  String
    property :alias, String

    validates_within :role, :set => ["impostor", "interrogator", "honest"]
    validates_within :alias, :set => ["A", "B", nil]

    belongs_to :user, :key => true
    belongs_to :game, :key => true
    has n, :answers
  end
end
