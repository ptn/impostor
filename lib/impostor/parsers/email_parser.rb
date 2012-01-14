require 'impostor/utils'

module Impostor
  module Parsers
    module EmailParser
      extend Impostor::Utils::LazyEval

      lazy_eval :body_parser,
        default: proc { |h, k| proc { |email_body| { k => email_body } } }

      body_parser :dummy do
        nil
      end

      def self.parse(subject, body)
        name, game_id = subject.split
        name = name.downcase.to_sym
        params = body_parsers[name].call body
        [name, game_id, params]
      end
    end
  end
end
