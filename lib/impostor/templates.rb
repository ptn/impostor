module Impostor
  module Templates
    @dir = "data/templates"

    def self.get(name)
      name += ".txt"
      fname = File.join(@dir, name)
      f = File.open(fname)
      result = f.read
      f.close
      result
    end
  end
end
