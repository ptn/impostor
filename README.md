An email-based implementation of the Turing test.

## General Workflow

The system stores every user's name and a description of herself. Games happen 
like this:

1. A user sends email with `START` as the subject. This player will be the 
interrogator.

2. The system chooses 2 players, A and B, at random from those that are 
available to play at the moment, one will have to tell the truth and the other 
will have to impersonate the first one. The system sends the following:

to the interrogator, the names and descriptions of A and B, and the game id

to the impersonator, the following: `A game will start, you will be 
impersonating <other player's name>, here's her description: <description>`

to the 3rd player: `A game will start, you will tell the truth, here's the 
description you submitted: <her own description>`

3. The interrogator sends an email with `ASK <game id>` as the subject and her 
question as the body.

4. The system relays the question to A and B in a mail with subject `ANSWER 
<game id>`.

5. They both reply with their answers, respecting their role.

6. The system relays the answers to the interrogator in one email, with the 
format: `Player A: \n\n Player B: `.

7. Steps 3 to 6 repeat as many times as the interrogator wants. When she is 
   ready to take a guess, she sends email with subject `GUESS <game id>` and 
the username of the impostor in the body.

8. The system emails all 3 players informing them if the interrogator succeeded 
or not.

(Clarification: Emails sent between the interrogator and the server have 
subject `QUESTION <game id>`, and between server and A and B have `ANSWER <game 
id>`.)


## Additional commands

* Users sign up by sending email with `REGISTER` as the subject and their names 
  and description as the body.

* To signal that they can be chosen to be a player, they send email with 
  `AVAILABLE` as the subject and an empty body; when they don't want to be 
chosen, they send `UNAVAILABLE` instead.

* Users can register directly as unavailable by sending `unavailable` at the 
  end of the body of their sign up email.

* Players can send a new description of themselves by using `EDIT` as the 
  subject.
