require_relative 'mailer'
require_relative 'parsers/email_parser'
require_relative 'commands'

module Impostor
  module Server
    #
    # For at least the last +count+ unread emails in the server, fire off the
    # corresponding command.
    #
    # +count+ can be an integer or :all
    #
    # Returns the number of emails processed.
    #
    def self.process(count, parser=Parsers::EmailParser.new)
      unread = mailer.get_unread(count)
      unread.each do |ur|
        args = parser.parse(ur.from.first, ur.subject, ur.body.decoded)
        Command.new.run *args
      end

      unread.count
    end

    private

    def self.mailer
      @mailer ||= Mailer.new
    end
  end
end
