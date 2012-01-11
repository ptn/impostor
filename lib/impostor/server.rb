require 'impostor/mailer'
require 'impostor/commands'

module Impostor
  module Server
    #
    # For at least the last <count> unread emails in the server, fire off the
    # corresponding command.
    #
    # +count+ can be an integer or :all
    #
    def self.process(count)
      unread = mailer.get_unread(count)
      unread.each do |ur|
        cmd = Commands.create(ur.subject, ur.body)
        cmd.run
      end
    end

    private

    def self.mailer
      @mailer ||= Mailer.new
    end
  end
end
