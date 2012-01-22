require_relative '../utils'

module Impostor
  module Parsers
    class EmailParser
      extend Utils::StoreProcs

      store_procs_with :body_parser,
        #FIXME Client code of StoreProcs should not know that it uses a hash,
        #this breaks the encapsulation!
        default: proc { |hash, key| proc { |body| { key => body } } }

      body_parser :edit do |body|
        { :description => body }
      end

      #
      # Extracts the name of the command to run and it's parameters.
      #
      # This method only parsers the subject of the mail, the body is parsed by
      # routines defined with the body_parser macro. These routines return a
      # hash that map the name of a parameter to it' value. If a body parser is
      # not provided for a given command, the result will be a mapping from the
      # command name to the complete body of the email.
      #
      # Returns the name of the command, the issuing user, the game and the
      # parameters hash.
      #
      # FIXME: breaks with HTML, should strip signatures, etc.
      #
      def parse(from, subject, body)
        name, game_id = subject.split

        name = name.downcase.to_sym
        params = body_parsers[name].call body

        sender = User.first(:email => from)
        game = Game.get(game_id)

        [name, params, sender, game]
      end
    end
  end
end
