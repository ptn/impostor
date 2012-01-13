module Impostor
  module Templates
    INFO_TO_INTERROGATOR = <<-BODY
                Hi, the new game you requested has started!

                To start asking, send me mail with subject "QUESTION %{game_id}"

                You will be playing with the following two players:

                %{username_a}
                %{email_a}

                %{description_a}

                %{username_b}
                %{email_b}

                %{description_b}
    BODY
  end
end
