require_relative '../utils'

module Impostor
  module Parsers
    class EmailParser
      #
      # Extracts the name of the command to run and it's parameters.
      #
      # This method only parsers the subject of the mail, the body is parsed by
      # methods called the same as the command. These methods are invoked by
      # the dispatcher called #parse_body and return a hash that map the name
      # of a parameter to it's value. If a body parser is not provided for a
      # given command, the method called #default_body_parser is invoked, which
      # returns a map with a single key :matched_text mapping to the complete
      # body of the email.
      #
      # Returns the name of the command, the issuing user, the game and the
      # parameters hash.
      #
      # FIXME: breaks with HTML, should strip signatures, etc.
      #
      def parse(from, subject, body)
        command, game_id = subject.split

        command = command.downcase.to_sym
        params  = parse_body body, :for => command

        sender = User.first(:email => from)
        game   = Game.get(game_id)

        [command, params, sender, game]
      end

      private

      def parse_body(body, opts)
        cmd = opts[:for]
        if cmd && respond_to? cmd
          send cmd, body
        else
          default_body_parser(body)
        end
      end

      def default_body_parser(body)
        { :match => body }
      end

      def register(body)
        split = body.split
        { :name => split[0], :description => split[1] }
      end
    end
  end
end
