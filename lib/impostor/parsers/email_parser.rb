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
        # Default value is a proc that takes the email_body and returns a hash
        # with the key used with @params_parsers pointing to the complete
        # email_body.
        @params_parsers ||= Hash.new do |h, k|
          proc { |email_body| { k => email_body } }
        end

        @params_parsers[name] = callback
      end

      params_parser :dummy do
        nil
      end
    end
  end
end
