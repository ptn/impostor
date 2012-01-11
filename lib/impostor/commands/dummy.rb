module Impostor
  module Commands
    class DummyCommand < Base
      def run
        puts "I'm a dummy command"
      end
    end
  end
end
