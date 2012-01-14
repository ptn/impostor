module Impostor
  class Question
    include DataMapper::Resource

    property :id,       Serial
    property :text,     Text
    property :answered, Boolean, :default => false

    belongs_to :game
    has n, :answers
  end
end
