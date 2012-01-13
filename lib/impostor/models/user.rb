module Impostor
  module Models
    class User
      include DataMapper::Resource

      property :id,          Serial
      property :email,       String,  :unique => true, :format => :email_address, :required => true
      property :username,    String,  :required => true
      property :description, Text,    :required => true
      property :available,   Boolean, :default => true

      has n, :players
      has n, :games, :through => :players
    end
  end
end
