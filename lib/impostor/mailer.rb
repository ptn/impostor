require 'mail'
require 'yaml'

module Impostor
  class Mailer
    def initialize(game=nil, config_file="~/.impostor/config.yaml")
      @game = game
      @config = parse_config(config_file)
      @email_address = @config[:smtp][:user_name] + "@" + @config[:smtp][:domain]

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

    def send_info_to_interrogator
      a, b          = @game.randomized_players
      interrogator  = @game.interrogator.email
      me            = @email_address
      id            = @game.id

      Mail.deliver do
        from    me
        to      interrogator
        subject "New game starting!"
        body    <<-BODY
                Hi, the new game you requested has started!

                To start asking, send me mail with subject "QUESTION #{id}"

                You will be playing with the following two players:

                #{a.email}
                #{a.username}

                #{a.description}

                #{b.email}
                #{b.username}

                #{b.description}
        BODY
      end
    end

    def send_info_to_impersonator
    end

    def send_info_to_honest
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
