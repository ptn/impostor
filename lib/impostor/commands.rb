require_relative 'utils'

module Impostor
  class Command
    extend Utils::StoreProcs

    #TODO Do real logging here.
    store_procs_with :command, default: proc { proc { puts "Command unknown" } }

    def initialize(presenter=Mailer.new)
      @presenter = presenter
    end

    def run(name, params, sender, game)
      if name == :register || !sender.nil?
        commands[name].call @presenter, params, sender, game
      end
    end

    command :start do |presenter, params, sender|
      game = Game.start(sender)

      presenter.send_info(game)
    end

    command :question do |presenter, params, sender, game|
      if sender == game.interrogator

        #TODO Enforce that a game can only have one unanswered question at the
        #model layer.
        if game.current_question
          presenter.reject_question(game)
        else
          question = Question.create(:text => params[:question], :game => game)
          presenter.send_question(game, question)
        end
      end
    end

    command :answer do |presenter, params, sender, game|
      if sender == game.impostor || sender == game.honest
        question = game.current_question
        player = Player.first(:user => sender, :game => game)

        answer = question.add_answer(params[:answer], player)

        if answer
          if question.answered?
            presenter.send_answers(game, question)
          end
        else
          presenter.reject_answer(game, sender, params[:answer])
        end
      end
    end

    command :guess do |presenter, params, sender, game|
      if sender == game.interrogator

        if game.take_guess(params[:guess])
          presenter.win(game)
        else
          presenter.lose(game)
        end
      end
    end

    command :edit do |presenter, params, sender|
      sender.description = params[:description]
      sender.save
      presenter.confirm_new_description(sender)
    end
  end
end
