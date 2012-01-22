require 'mail'
require 'impostor/templates'

require_relative '../../config/mail_configuration'

module Impostor
  class Mailer
    def initialize(game=nil)
      @game = game
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

    def send_info
      send_info_to_interrogator
      send_info_to_impostor
      send_info_to_honest
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

    def send_answers(question)
      context = {
        question: question.text,
        answer_a: question.answer_a.text,
        answer_b: question.answer_b.text,
        game_id: @game.id,
      }

      send_email_to(
        @game.interrogator.email,
        "Answers for question on game #{@game.id}",
        Templates::ANSWER % context
      )
    end

    def reject_answer(user, answer)
      send_email_to(
        user.email,
        "Rejected answer",
        Templates::REJECTED_ANSWER % { answer: answer }
      )
    end

    def win
      send_email_to(
        @game.interrogator.email,
        "You Win!",
        Templates::INTERROGATOR_WIN
      )

      [@game.impostor, @game.honest].each do |user|
        send_email_to(
          user.email,
          "You Lose :-(",
          Templates::PLAYERS_LOSE
        )
      end
    end

    def lose
      send_email_to(
        @game.interrogator.email,
        "You Lose :-(",
        Templates::INTERROGATOR_LOSE
      )

      [@game.impostor, @game.honest].each do |user|
        send_email_to(
          user.email,
          "You Win!",
          Templates::PLAYERS_WIN
        )
      end
    end

    def confirm_new_description(sender)
      send_email_to(
        sender.email,
        "Your description was updated",
        Templates::NEW_DESCRIPTION % { description: sender.description }
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

    def send_info_to_interrogator
      interrogator  = @game.interrogator.email

      context = {
        game_id: @game.id,
        email_a: @game.player_a.user.email,
        username_a: @game.player_a.user.username,
        description_a: @game.player_a.user.description,
        email_b: @game.player_b.user.email,
        username_b: @game.player_b.user.username,
        description_b: @game.player_b.user.description,
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
  end
end
