require 'impostor/utils'

module Impostor
  module Parsers
    module EmailParser
      extend Impostor::Utils::LazyEval

      lazy_eval :body_parser,
        default: proc { |hash, key| proc { |body| { key => body } } }

      #
      # Extracts the name of the command to run and it's parameters.
      #
      # This method only parsers the subject of the mail, the body is parsed by
      # routines defined with the body_parser macro. These routines return a
      # hash that map the name of a parameter to it' value. If a body parser is
      # not provided for a given command, the result will be a mapping from the
      # command name to the complete body of the email.
      #
      # Returns the name of the command, the game and the parameters
      # hash.
      #
      # FIXME: breaks with HTML, should strip signatures, etc.
      #
      def self.parse(subject, body)
        name, game_id = subject.split

        name = name.downcase.to_sym
        params = body_parsers[name].call body

        [name, game_id, params]
      end
    end
  end
end
