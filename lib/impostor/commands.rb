require 'impostor/utils'

module Impostor
  module Commands
    extend Impostor::Utils::LazyEval

    #TODO Do real logging here.
    lazy_eval :command, default: proc { proc { puts "Command unknown" } }

    command :dummy do
      puts "Hi! I'm a dummy command"
    end

    command :question do |game_id, params|
      puts "Someone asked in game #{game_id}: #{params[:question]}"
    end

    command :answer do |game_id, params|
      puts "Someone answered in game #{game_id}: #{params[:answer]}"
    end

    def self.run(name, game_id, params)
      commands[name].call game_id, params
    end
  end
end
