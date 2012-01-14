module Impostor
  class Answer
    include DataMapper::Resource

    property :id,   Serial
    property :text, Text, :required => true

    belongs_to :question

    def game
      question.game
    end
  end
end

