require "impostor/commands/base"
require "impostor/commands/start"
require "impostor/commands/ask"
require "impostor/commands/answer"
require "impostor/commands/solve"
require "impostor/commands/register"
require "impostor/commands/edit"
require "impostor/commands/dummy"

module Impostor
  module Commands
    #
    # Instantiate the command that carries out the action specified in an
    # email.
    #
    def self.create(email_subject, email_body)
      name, game_id = email_subject.split
      raw_params = email_body
      cls = get_cmd_cls(name)
      cmd = cls.new(raw_params, game_id)
    end

    private

    def self.get_cmd_cls(name)
      full_name = name.capitalize + "Command"
      Impostor::Commands.const_get(full_name)
    end
  end
end
