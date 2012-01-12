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

  end
end
