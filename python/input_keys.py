# Levi

import game_data as gd
import os
import sys


# Reads keys until key_to_dir gives something other than -1
# params: none
# return: a direction (0-3 which correspond to left right up down respectively, or gd.QUIT (aka -2)
def get_input():
    while True:
        keyStroke = get_key()

        currentDirection = key_to_dir(keyStroke)

        if currentDirection != -1:
            return currentDirection


# *This method is copy pasted from a google search. It is only used for the python build of this game 
# Helper method for get_input() that handles reading the actual keyboard input
# params: none
# return: a single character cooresponding to the key that was pressed
def get_key():
    if os.name == 'nt':  # Windows
        import msvcrt
        # getch returns bytes, decode it to a string
        return msvcrt.getch().decode('utf-8', errors='ignore')
    else:  # macOS / Linux
        import tty
        import termios
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            ch = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        return ch

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

# Ignores every key except R (restart) and Q (quit)
# params: none
# returns: boolean (True if Restart, False if Quit)
def wait_for_restart():
    while True:
            keyStroke = get_key()
    
            match keyStroke:
                case "R" | "r":
                    return True
                case "Q" | "q":
                    return False

# method for dubugging. prints the direction moved
# params: int direction
# return: none
def print_dir_moved(direction):
    match direction:
        case gd.UP:
            print("*moved up")
        case gd.DOWN:
            print("*moved down")
        case gd.LEFT:
            print("*moved left")
        case gd.RIGHT:
            print("*moved right")