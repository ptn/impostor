require 'mail'
require 'yaml'
require 'impostor/templates'

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
      interrogator  = @game.interrogator.email
      me            = @email_address
      a, b          = @game.randomized_players_as_users

      context = {
        game_id: @game.id,
        email_a: a.email,
        username_a: a.username,
        description_a: a.description,
        email_b: b.email,
        username_b: b.username,
        description_b: b.description,
      }

      Mail.deliver do
        from    me
        to      interrogator
        subject "New game starting!"
        body    Templates::INFO_TO_INTERROGATOR % context
      end
    end

    def send_info_to_impostor
      impostor = @game.impostor.email
      me           = @email_address

      context = {
        interrogator_username: @game.interrogator.username,
        interrogator_email: @game.interrogator.email,
        other_username: @game.honest.username,
        other_email: @game.honest.email,
        role: "impostor",
        description: @game.honest.description,
      }

      Mail.deliver do
        from    me
        to      impostor
        subject "New game starting!"
        body    Templates::INFO_TO_PLAYER % context
      end
    end

    def send_info_to_honest
      honest = @game.honest.email
      me     = @email_address

      context = {
        interrogator_username: @game.interrogator.username,
        interrogator_email: @game.interrogator.email,
        other_username: @game.impostor.username,
        other_email: @game.impostor.email,
        role: "honest",
        description: @game.honest.description,
      }

      Mail.deliver do
        from    me
        to      honest
        subject "New game starting!"
        body    Templates::INFO_TO_PLAYER % context
      end
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
