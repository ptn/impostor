module Impostor
  class Command
    # Convenience so that client code doesn't have to instantiate an object
    # only to throw it away the next second.
    def self.run(*args)
      new.run(*args)
    end

    def initialize(presenter=Mailer.new)
      @presenter = presenter
    end

    def run(cmd, params, sender, game)
      if cmd == :register || !sender.nil?
        execute cmd, sender, game, params
      end
    end

    private

    def execute(cmd, sender, game, params)
      if respond_to?(cmd, true)
        send cmd, sender, game, params
      else
        unknown_command
      end
    end

    #TODO Do real logging here.
    def unknown_command
      puts "Unknown command"
    end

    def start(sender, game, params)
      game = Game.start(sender)
      @presenter.send_info(game)
    end

    def question(sender, game, params)
      if sender == game.interrogator

        #TODO Enforce that a game can only have one unanswered question at the
        #model layer.
        if game.current_question
          @presenter.reject_question(game)
        else
          question = Question.create(:text => params[:match], :game => game)
          @presenter.send_question(game, question)
        end
      end
    end

    def answer(sender, game, params)
      if sender == game.impostor || sender == game.honest
        question = game.current_question
        player = Player.first(:user => sender, :game => game)

        answer = question.add_answer(params[:match], player)

        if answer
          if question.answered?
            @presenter.send_answers(game, question)
          end
        else
          @presenter.reject_answer(game, sender, params[:match])
        end
      end
    end

    def guess(sender, game, params)
      if sender == game.interrogator

        if game.take_guess(params[:match])
          @presenter.win(game)
        else
          @presenter.lose(game)
        end
      end
    end

    def edit(sender, game, params)
      sender.description = params[:match]
      sender.save
      @presenter.confirm_new_description(sender)
    end
  end
end
