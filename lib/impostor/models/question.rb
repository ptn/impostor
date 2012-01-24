module Impostor
  class Question
    include DataMapper::Resource

    property :id,       Serial
    property :text,     Text,    :required => true
    property :answered, Boolean, :default => false

    belongs_to :game
    has n, :answers

    def add_answer(answer_text, player)
      unless already_answered? player
        answer = Answer.create(
          :text => answer_text,
          :question => self,
          :player => player
        )

        if answers.count == 2
          self.answered = true
          self.save
        end

        answer
      end
    end

    def already_answered?(player)
      answers.first(:player => player)
    end

    def answer_a
      answers.select { |ans| ans.player.alias == "A" }.first
    end

    def answer_b
      answers.select { |ans| ans.player.alias == "B" }.first
    end
  end
end
