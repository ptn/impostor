require 'impostor/utils'

module Impostor
  module Commands
    extend Impostor::Utils::LazyEval

    #TODO Do real logging here.
    lazy_eval :command, default: proc { proc { puts "Command unknown" } }

    def self.run(name, sender, game, params)
      commands[name].call sender, game, params
    end

    command :start do |sender, game, params|
      game = Game.start(sender)

      mailer = Mailer.new(game)
      mailer.send_info_to_interrogator
      mailer.send_info_to_impostor
      mailer.send_info_to_honest
    end

    command :question do |sender, game, params|
      if sender == game.interrogator
        mailer = Mailer.new(game)

        #TODO Enforce that a game can only have one unanswered question at the
        #model layer.
        if game.current_question
          mailer.reject_question
        else
          question = Question.create(:text => params[:question], :game => game)
          mailer.send_question question
        end
      end
    end

    command :answer do |sender, game, params|
      if sender == game.impostor || sender == game.honest
        question = game.current_question
        player = Player.first(:user => sender, :game => game)

        answer = question.add_answer(params[:answer], player)

        mailer = Mailer.new(game)
        if answer
          if question.answered?
            mailer.send_answers(question)
          end
        else
          mailer.reject_answer(sender, params[:answer])
        end
      end
    end

    command :guess do |sender, game, params|
      if sender == game.interrogator
        mailer = Mailer.new(game)

        if game.take_guess(params[:guess])
          mailer.win
        else
          mailer.lose
        end
      end
    end
  end
end
