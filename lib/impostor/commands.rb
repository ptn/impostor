require 'impostor/utils'

module Impostor
  module Commands
    extend Impostor::Utils::LazyEval

    #TODO Do real logging here.
    lazy_eval :command, default: proc { proc { puts "Command unknown" } }

    command :dummy do
      puts "Hi! I'm a dummy command"
    end

    command :question do |sender, game, params|
      puts "Someone asked in game #{game}: #{params[:question]}"
    end

    command :answer do |sender, game, params|
      puts "Someone answered in game #{game}: #{params[:answer]}"
    end

    def self.run(name, sender_address, game_id, params)
      sender = Models::User.first(:email => sender_address)
      if sender
        game = Models::Game.get(game_id)
        commands[name].call sender, game, params
      end
    end
  end
end
