# Levi

import game_data as gd


# just does gd.score += points, as can be seen
# params: points - int value corresponding to how many points should be added
# return: void
def update_score(points):
    gd.score += points


# inserts s into gd.high_scores, which must stay in sorterd order; the lowest drops off. Uses a loop rather than sorted() so easy conversion to assembly
# params: s - int value, the score to be added to the scoreboard
# return: void
def add_high_score(s):
    # if s is less than lowest score, exit - don't need to add the new score
    if s <= gd.high_scores[4]:
        return
    for index, score in reversed(enumerate(gd.high_scores)):
        # TODO: starthere. model this like you'd have to do in mips: shift everything right until you reach the correct spot and insert there (should dropoff last val)
        # if index == gd.
