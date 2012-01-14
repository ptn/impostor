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

      send_email_to(
        interrogator,
        "New game starting!",
        Templates::INFO_TO_INTERROGATOR % context
      )
    end

    def send_info_to_impostor
      impostor = @game.impostor.email

      context = {
        interrogator_username: @game.interrogator.username,
        interrogator_email: @game.interrogator.email,
        other_username: @game.honest.username,
        other_email: @game.honest.email,
        role: "impostor",
        description: @game.honest.description,
      }

      send_email_to(
        impostor,
        "New game starting!",
        Templates::INFO_TO_PLAYER % context
      )
    end

    def send_info_to_honest
      honest = @game.honest.email

      context = {
        interrogator_username: @game.interrogator.username,
        interrogator_email: @game.interrogator.email,
        other_username: @game.impostor.username,
        other_email: @game.impostor.email,
        role: "honest",
        description: @game.honest.description,
      }

      send_email_to(
        honest,
        "New game starting!",
        Templates::INFO_TO_PLAYER % context
      )
    end

    def reject_question
      send_email_to(
        @game.interrogator.email,
        "Question rejected",
        Templates::REJECTED_QUESTION
      )
    end

    def send_question(question)
      context = {
        question: question.text,
        game_id: @game.id,
        description: @game.honest.description,
      }

      send_email_to(
        @game.impostor.email,
        "Game question",
        Templates::QUESTION % context.merge({role: "impostor"})
      )

      send_email_to(
        @game.honest.email,
        "Game question",
        Templates::QUESTION % context.merge({role: "honest"})
      )
    end

    def send_email_to(you, subject, body)
      me = @email_address

      Mail.deliver do
        from    me
        to      you
        subject subject
        body    body
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
