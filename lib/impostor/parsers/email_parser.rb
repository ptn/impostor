module Impostor
  module Parsers
    module EmailParser

      def self.parse(subject, body)
        name, game_id = subject.split
        name = name.downcase.to_sym
        params = @params_parsers[name].call body
        [name, game_id, params]
      end

      def self.params_parser(name, &callback)
        @params_parsers ||= Hash.new { proc { nil } }
        @params_parsers[name] = callback
      end

      params_parser :dummy, do
        nil
      end

    end
  end
end
