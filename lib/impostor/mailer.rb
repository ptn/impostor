require 'mail'
require 'erb'

require_relative 'templates'

module Impostor
  class Mailer
    def initialize
      @email_address = MailConfiguration::SMTP::USER_NAME + "@" +
        MailConfiguration::SMTP::DOMAIN

      configure_smtp
      configure_pop3
    end

    #
    # Get +count+ unread emails from the server.
    #
    # +count+ can be an integer or :all
    #
    def get_unread(count)
      Mail.last :count => count
    end

    def send_info(game)
      send_info_to_interrogator(game)
      send_info_to_impostor(game)
      send_info_to_honest(game)
    end

    def reject_question(game)
      template = ERB.new(Templates.get('rejected_question'))
      send_email_to(
        game.interrogator.email,
        "Question rejected",
        template.result
      )
    end

    def send_question(game, question)
      question = question.text
      game_id = game.id
      description = game.honest.description

      template = ERB.new(Templates.get("question"))

      role = "impostor"
      send_email_to(
        game.impostor.email,
        "Game question",
        template.result(binding)
      )

      role = "honest"
      send_email_to(
        game.honest.email,
        "Game question",
        template.result(binding)
      )
    end

    def send_answers(game, question)
      answer_a = question.answer_a.text
      answer_b = question.answer_b.text
      game_id = game.id

      template = ERB.new(Templates.get("answer"))

      send_email_to(
        game.interrogator.email,
        "Answers for question on game #{game.id}",
        template.result(binding)
      )
    end

    def reject_answer(game, user, answer)
      template = ERB.new(Templates.get("rejected_answer"))
      send_email_to(
        user.email,
        "Rejected answer",
        template.result(binding)
      )
    end

    def win(game)
      template = ERB.new(Templates.get('interrogator_win'))
      send_email_to(
        game.interrogator.email,
        "You Win!",
        template.result
      )

      [game.impostor, game.honest].each do |user|
      template = ERB.new(Templates.get('players_lose'))
        send_email_to(
          user.email,
          "You Lose :-(",
          template.result
        )
      end
    end

    def lose(game)
      template = ERB.new(Templates.get('interrogator_lose'))
      send_email_to(
        game.interrogator.email,
        "You Lose :-(",
        template.result
      )

      [game.impostor, game.honest].each do |user|
        template = ERB.new(Templates.get('players_win'))
        send_email_to(
          user.email,
          "You Win!",
          template.result
        )
      end
    end

    def confirm_new_description(sender)
      template = ERB.new(Templates.get('new_description'))
      send_email_to(
        sender.email,
        "Your description was updated",
        template.result(binding)
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

    def configure_smtp
      Mail.defaults do
        delivery_method :smtp,
          address:              MailConfiguration::SMTP::ADDRESS,
          port:                 MailConfiguration::SMTP::PORT,
          user_name:            MailConfiguration::SMTP::USER_NAME,
          domain:               MailConfiguration::SMTP::DOMAIN,
          password:             MailConfiguration::SMTP::PASSWORD,
          authentication:       MailConfiguration::SMTP::AUTHENTICATION,
          enable_starttls_auto: MailConfiguration::SMTP::ENABLE_STARTTLS_AUTO
      end
    end

    def configure_pop3
      Mail.defaults do
        retriever_method :pop3,
          address:    MailConfiguration::POP3::ADDRESS,
          port:       MailConfiguration::POP3::PORT,
          user_name:  MailConfiguration::POP3::USER_NAME,
          password:   MailConfiguration::POP3::PASSWORD,
          enable_ssl: MailConfiguration::POP3::ENABLE_SSL
      end
    end

    private

    def send_info_to_interrogator(game)
      interrogator  = game.interrogator.email
      template = ERB.new(Templates.get("info_to_interrogator"))
      send_email_to(
        interrogator,
        "New game starting!",
        template.result(binding)
      )
    end

    def send_info_to_impostor(game)
      impostor = game.impostor.email
      other_username = game.honest.username
      other_email = game.honest.email
      description = game.honest.description
      role = "impostor"

      template = ERB.new(Templates.get("info_to_player"))

      send_email_to(
        impostor,
        "New game starting!",
        template.result(binding)
      )
    end

    def send_info_to_honest(game)
      honest = game.honest.email
      other_username = game.impostor.username
      other_email = game.impostor.email
      description = game.honest.description
      role = "honest"

      template = ERB.new(Templates.get("info_to_player"))

      send_email_to(
        honest,
        "New game starting!",
        template.result(binding)
      )
    end
  end
end
