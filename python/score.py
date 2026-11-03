# Levi

import game_data as gd


# just does gd.score += points, as can be seen
# params: points - int value corresponding to how many points should be added
# return: void
def update_score(points):
    gd.score += points

# inserts s into gd.high_scores, which must stay in sorterd order; the lowest drops off. Uses a loop rather than sorted() so easy conversion to assembly
# loops backwards and shifts values down until it finds the location to insert
# params: s - int value, the score to be added to the scoreboard
# return: void
def add_high_score(s):
    # if s is less than lowest score, exit - don't need to add the new score
    if s <= gd.high_scores[4]:
        return

    i = len(gd.high_scores) - 2 # loop from 2nd to last index, to 0
    while i >= 0:
        if gd.high_scores[i] < s:
            # shift down
            gd.high_scores[i + 1] = gd.high_scores[i]
        else:
            break
        i -= 1
    gd.high_scores[i + 1] = s
    