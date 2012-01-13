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

      Good luck!
    BODY

    INFO_TO_PLAYER = <<-BODY
      Hi, you have been chosen to participate in a new game!

      The game was started by %{interrogator_username} (%{interrogator_email}), the other player will be %{other_username} (%{other_email}).
      You will be the %{role} player, so here's the description you have to play by:

      %{description}

      Good luck!
    BODY

    QUESTION = <<-BODY
      The interrogator asks:

      %{question}

      Please send me mail with subject "ANSWER %{game_id}" with your answer.
      Remember that you are playing %{role}, here's the description to play by:

      %{description}
    BODY
  end
end
