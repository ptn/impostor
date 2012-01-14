module Impostor
  class User
    include DataMapper::Resource

    property :id,          Serial
    property :email,       String,  :unique => true, :format => :email_address, :required => true
    property :username,    String,  :required => true
    property :description, Text,    :required => true
    property :available,   Boolean, :default => true

    has n, :players
    has n, :games, :through => :players

    def self.available
      all(:available => true)
    end

    def self.pick_for_new_game(opts)
      query = <<-SQL
      SELECT id, username, email, description
      FROM impostor_models_users
      WHERE id <> ?
      AND available = 't'
      ORDER BY RANDOM()
      LIMIT 2
      SQL

      a, b = repository(:default).adapter.select(
        query, [opts[:exclude].id]
      )
    end

    def status
      self.available? ? :available : :unavailable
    end
  end
end
