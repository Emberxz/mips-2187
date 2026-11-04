# ----------------- MAIN -----------------
# Run this file to start the program!
# ----------------------------------------

# Levi

import game_data as gd
import input_keys as ik
import start_screen as ss
import matrix as mat
import display as d
import move as mov
import score as s
import check_mat as cm

# main program method. begins on the start screen
# params: none
# return: none
def main():
    while True:
        # begin program on  start screen. this allows you to do valid start screen actions, it returns when you begin a game (hitting z)
        command = ss.start_screen()
        if command == gd.START_GAME:
            playAgain = True
            while playAgain:
                playAgain = play_one_game()     # enter game loop. when game is over, playAgain is redetermined
        elif command == gd.QUIT_PROGRAM:
            break;


# simulate one game of 2187
# params: none
# returns: Boolean, True if user decides to play again, False if user decides to quit (return to start screen)
def play_one_game():
    print("*starting a game")
    print("*valid keybinds: WASD to slide tiles, Q to quit game")
    
    mat.init_matrix()
    d.print_matrix()

    while True:
        direction = ik.get_input()
        if direction == gd.QUIT:
            s.add_high_score(gd.score)
            break
        
        pointsFromMove = mov.move(direction)
        if pointsFromMove == -1:
            print("*invalid move")  # this is just for python version. need to dertermine how we want to show a move does nothing (or just do nothing?)
            continue
        s.update_score(pointsFromMove)
        print("\n*current score: " + str(gd.score))

        d.print_matrix()

        gameState = cm.check_mat()
        match gameState:
            case gd.CONTINUE:
                mat.spawn_tile()
                continue
            case gd.WIN:
                d.you_win()
            case gd.LOSS:
                d.you_lose()

        # if we've gotten here, you've either lost or won
        s.add_high_score(gd.score)      # NOTE that if we want to nav to scoreboard if this game made a new highscore,
                                        # then add_high_score() needs to determine this and return something so we can do so here

        return ik.wait_for_restart() 


# BEGIN THE GAME!!!!!
main()