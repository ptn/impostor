require 'impostor/utils'

module Impostor
  module Commands
    extend Utils::StoreProcs

    #TODO Do real logging here.
    store_procs_with :command, default: proc { proc { puts "Command unknown" } }

    def self.run(name, sender, params, game)
      if name == :register || !sender.nil?
        commands[name].call sender, params, game
      end
    end

    command :start do |sender, params|
      game = Game.start(sender)

      mailer = Mailer.new(game)
      mailer.send_info
    end

    command :question do |sender, params, game|
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

    command :answer do |sender, params, game|
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

    command :guess do |sender, params, game|
      if sender == game.interrogator
        mailer = Mailer.new(game)

        if game.take_guess(params[:guess])
          mailer.win
        else
          mailer.lose
        end
      end
    end

    command :edit do |sender, params|
      sender.description = params[:description]
      sender.save
      Mailer.new.confirm_new_description(sender)
    end

    command :register do |sender, params|
      unless sender
        user = User.new(params)
        mailer = Mailer.new

        if user.save
          mailer.confirm_registration(user)
        else
          mailer.reject_registration(user)
        end
      end
    end

  end
end
