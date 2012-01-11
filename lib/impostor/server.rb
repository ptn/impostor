require 'impostor/mailer'
require 'impostor/commands'

module Impostor
  module Server
    #
    # For at least the last <count> unread emails in the server, fire off the
    # corresponding command.
    #
    # A <count> of -1 means to process all unread messages.
    #
    def self.process(count=-1)
      unread = mailer.get_unread(count)
      unread.each do |ur|
        cmd = Commands.create(ur.subject, ur.body)
        cmd.run
      end
    end

    def self.process_all()
      self.process
    end

    private

    def self.mailer
      @mailer ||= Mailer.new
    end
  end
end
