require 'impostor/mailer'
require 'impostor/parsers/email_parser'
require 'impostor/commands'

module Impostor
  module Server
    #
    # For at least the last <count> unread emails in the server, fire off the
    # corresponding command.
    #
    # If a command was sent by a non-registered user, ignore it.
    #
    # +count+ can be an integer or :all
    #
    #TODO Should return something useful
    def self.process(count, parser=Parsers::EmailParser)
      unread = mailer.get_unread(count)
      unread.each do |ur|
        cmd_name, sender, game, params = parser.parse(ur.from, ur.subject, ur.body)
        Commands.run cmd_name, sender, params, game if sender
      end
    end

    private

    def self.mailer
      @mailer ||= Mailer.new
    end
  end
end
