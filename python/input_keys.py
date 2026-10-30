# Levi

import game_data as gd


# Reads keys until key_to_dir gives something other than -1
# params: none
# return: a direction (0-3 which correspond to left right up down respectively, or gd.QUIT
def get_input():
    #TODO: this needs work, need to determine where the looping to get input actually happens (in main? probably), and how to actually read input
    while True:
        keyStroke = "GET THE KEY HERE!"

        currentDirection = key_to_dir()

        if currentDirection == -1:
            break
        


# converts key to direction
# params: a key
# return: a direction (0-3, which correspond to left right up down respectively), gd.QUIT, or -1 if key isn't valid input
def key_to_dir(key):
    match key:
        case "W" | "w":
            return gd.UP
        case "A" | "a":
            return gd.LEFT
        case "S" | "s":
            return gd.DOWN
        case "D" | "d":
            return gd.RIGHT
        case "Q" | "q":
            return gd.QUIT
    return -1

def wait_for_restart():
    return 0 