# Levi

import game_data as gd
import input_keys as ik

# Prints the start menu, and responds to valid start menu commands (Z - start a game, Q - quit the program, X - show scoreboard, T - toggle theme)
# params: none
# return: gd.START_GAME (aka 3) or gd.QUIT_PROGRAM (aka -3)
def start_screen():
    print_start_menu()

    while True:
        keyStroke = ik.get_key()

        match keyStroke:
            case "Z" | "z":
                return gd.START_GAME
            case "Q" | "q":
                return gd.QUIT_PROGRAM
            case "X" | "x":
                show_scores()
                print_start_menu()
            case "T" | "t":
                print("The theme has been changed to " + str(gd.theme) + " (*only visible in mips graphics)")
                change_theme()
            
# Toggles the theme; toggles the gd.theme value, which can be 0 (Home Game) or 1 (Away Game)
# params: none
# returns: none
def change_theme():
    if gd.theme == 0:
        gd.theme = 1
    elif gd.theme == 1:
        gd.theme = 0

# Prints the high scores and waits for X to be hit to exit the high score screen (return to start menu)
# params: none
# returns none
def show_scores():
    print("\n        HIGH SCORES\n")
    # print high scores
    for index, score in enumerate(gd.high_scores):
        print(str(index + 1) + ". " + str(score))

    print("\n[ X ] Return to Start Menu")

    while True:
        keyStroke = ik.get_key()

        if (keyStroke == "X" or keyStroke == "x"):
            return

# helper method
def print_start_menu():
    print("""
        WELCOME TO 2187

        [ Z ]  Start Game
        [ Q ]  Quit Program
        [ X ]  Scoreboard
        [ T ]  Toggle Theme

    """)