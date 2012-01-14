require 'impostor/utils'

module Impostor
  module Commands
    extend Impostor::Utils::LazyEval

    #TODO Do real logging here.
    lazy_eval :command, default: proc { proc { puts "Command unknown" } }

    command :start do |sender, game, params|
      game = Game.start(sender)
      mailer = Mailer.new(game)
      mailer.send_info_to_interrogator
      mailer.send_info_to_impostor
      mailer.send_info_to_honest
    end

    command :question do |sender, game, params|
      question = Question.create(:text => params[:question], :game => game)

      Mailer.new(game).send_question question
    end

    command :answer do |sender, game, params|
      puts "Someone answered in game #{game}: #{params[:answer]}"
    end

    def self.run(name, sender_address, game_id, params)
      sender = User.first(:email => sender_address)
      if sender
        game = Game.get(game_id)
        commands[name].call sender, game, params
      end
    end
  end
end
