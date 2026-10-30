# Levi (August's implementation of grahics
# will replace this in assembly)

import game_data as gd

# prints the current game board
# params: none
# return: void
def print_matrix():
    for index, value in enumerate(gd.matrix):
        if index % 4 == 0:
            print("\n")
        print(str(gd.pow3[value]) + (" " * (-1 * len(str(gd.pow3[value])) + 6) ), end="") # looks funny but it keeps the columns in line
