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

    REJECTED_QUESTION = <<-BODY
      Sorry, you have to wait for every player to answer your previous question before asking a new one.
    BODY

    ANSWER = <<-BODY
      Your latest question was:

      %{question}

      Here are the answers of both players:

      Player A:
      %{answer_a}

      Player B:
      %{answer_b}


      To ask another question, send me email with subject "QUESTION %{game_id}".

      To take your guess, send me email with subject "GUESS %{game_id}" and
      the username of which player (A or B) you think is the impersonator.
    BODY

    REJECTED_ANSWER = <<-BODY
      We are sorry, your answer:

      %{answer}

      was rejected, because you can't answer the same question more than once.
    BODY

    INTERROGATOR_WIN = <<-BODY
      Your guess was correct! Congratulations!
    BODY

    PLAYERS_WIN = <<-BODY
      The interregotor couldn't guess your roles! Congratulations!
    BODY

    INTERROGATOR_LOSE = <<-BODY
      Nu-uh! That's not right - you lose!
    BODY

    PLAYERS_LOSE = <<-BODY
      The interrogator guessed correctly! You lose!
    BODY

    NEW_DESCRIPTION = <<-BODY
      Done! Your new description now is:

      %{description}
    BODY
  end
end
