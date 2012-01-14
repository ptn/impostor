module Impostor
  class Answer
    include DataMapper::Resource

    property :id,   Serial
    property :text, Text

    belongs_to :question
  end
end

