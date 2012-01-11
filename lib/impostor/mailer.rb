require 'mail'
require 'yaml'

module Impostor
  class Mailer
    def initialize(config_file="~/.impostor/config.yaml")
      @config = parse_config(config_file)
      configure_smtp @config[:smtp]
      configure_pop3 @config[:pop3]
    end

    #
    # Get +count+ unread emails from the server.
    #
    # +count+ can be an integer or :all
    #
    def get_unread(count)
      Mail.last :count => count
    end

    def configure_smtp(config)
      Mail.defaults do
        delivery_method :smtp, config
      end
    end

    def configure_pop3(config)
      Mail.defaults do
        retriever_method :pop3, config
      end
    end

    private

    def parse_config(config_file)
      file = File.expand_path(config_file)
      config = YAML.load_file(file)

      # Symbolize keys
      config["smtp"] = config["smtp"].inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo }
      config["pop3"] = config["pop3"].inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo }
      config.inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo }
    end
  end
end
