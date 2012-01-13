module Impostor
  module Models
    class Player
      include DataMapper::Resource

      property :id,   Serial
      property :role, String

      validates_within :role, :set => ["impostor", "interrogator", "honest"]

      belongs_to :user, :key => true
      belongs_to :game, :key => true
    end
  end
end
