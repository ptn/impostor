module Impostor
  class Question
    include DataMapper::Resource

    property :id,       Serial
    property :text,     Text,    :required => true
    property :answered, Boolean, :default => false

    belongs_to :game
    has n, :answers

    def add_answer(answer_text)
      answer = Answer.create(:text => answer_text, :question => self)
      if answers.count == 2
        answered = true
        self.save
      end
    end
  end
end
