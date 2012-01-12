module Impostor
  module Commands

    def self.run(name, game_id, params)
      @commands[name].call game_id, params
    end

    def self.command(name, &callback)
      #TODO Do real logging in the default block.
      @commands ||= Hash.new { proc { puts "Command unknown" } }
      @commands[name] = callback
    end

    command :dummy do
      puts "Hi! I'm a dummy command"
    end

    command :question do |game_id, params|
      puts "Someone asked in game #{game_id}: #{params[:question]}"
    end

    command :answer do |game_id, params|
      puts "Someone answered in game #{game_id}: #{params[:answer]}"
    end

  end
end
