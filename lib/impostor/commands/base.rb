module Impostor
  module Commands
    class Base

      attr_reader :game_id

      def initialize(raw_params, game_id)
        @game_id = game_id
        parse_raw_params(raw_params)
      end

      private

      def parse_raw_params(raw)
        raw
      end

    end
  end
end
