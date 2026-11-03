# ----------------- MAIN -----------------
# Run this file to start the program!
# ----------------------------------------

# Levi

import game_data as gd
import input_keys as ik
import start_screen as ss

def main():
    while True:
        # begin program on  start screen. this allows you to do valid start screen actions, it returns when you begin a game (hitting z)
        command = ss.start_screen()
        if command == gd.START_GAME:
            play_one_game()
        elif command == gd.QUIT_PROGRAM:
            break;
    #TODO: continue here

    
def play_one_game():
    return 0 


# BEGIN THE GAME!!!!!
main()