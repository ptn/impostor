require 'impostor/utils'

module Impostor
  module Parsers
    module EmailParser
      extend Impostor::Utils::LazyEval

      lazy_eval :body_parser,
        default: proc { |h, k| proc { |body| { k => body } } }

      # Needs more work: breaks with HTML, should strip signatures, etc.
      def self.parse(subject, body)
        name, game_id = subject.split
        name = name.downcase.to_sym
        params = body_parsers[name].call body
        [name, game_id, params]
      end
    end
  end
end
