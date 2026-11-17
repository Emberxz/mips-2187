# 2178
# COMP3550 Fall 2026
# Created by: August Basinger, Levi Webb, Phillip Gill, Jacob Womack, Caleb Stewart

# ------- All game data goes here -------
# * see game_data.py for what each means
.data
imageBuffer: .space 0x80000 # allocate space for 512 x 256 x 4 (each pixel is stored with a word)

matrix: .word 0:16 	   # OFFSET TO ACCESS A VALUE: offset = (rowNum * 4 + colNum) * 4 (row and col vals are 0-3)	
		   	   # *stored in row-major order	**4 rows * 4 cols = 16 words (ints)

score: .word 0		   # must be loaded into 2 registers; reguires lui and ori insturctions
			   # *the maximum score a 32 bit int can store is 2,147,483,647
			   
theme: .byte 0		   # theme is effectively a boolean value. loaded as a single byte because there are only 2 themes

high_scores: .word 0: 5	   # initilize a 5 int array, all ints set  to 0

pow3: .word 0, 3, 9, 27, 81, 243, 729, 2187, 6561, 19683, 59049, 177147

# constants:
.eqv WIN_EXP 11
.eqv LEFT 0
.eqv RIGHT 1
.eqv UP 2
.eqv DOWN 3

.eqv QUIT_PROGRAM -3
.eqv QUIT -2
.eqv CONTINUE 0
.eqv WIN 1
.eqv LOSS 2
.eqv START_GAME 3


# ------- All game logic goes here -------
.text

# main game loop
main:
jal start_screen	 # build start screen. method loop ends when the game is started (START_GAME returned) or program is exited (QUIT_PROGRAM returned) 

beq $v0, START_GAME, play_again_loop
# start_screen can only return START_GAME or QUIT_PROGRAM. if we made it here, quit the program:
li $v0, 10
syscall

play_again_loop:
jal play_one_game	# play a game; returns into $v0 whether or not the user will play another game
beq $v0, 1, play_again_loop	# user selected to play again, jump back to top of play_again_loop
j main			# user selected not to play again, jump to top of main loop to reload start screen


# method: play_one_game
play_one_game:
# registers used:
# $s0 ---> a direction constant; the direction the user chooses to slide the board


######## TODO: update this and the destroy stack frame to do so for all registers used (shown above)
addi $sp, $sp, -4	# allocate space on the stack for $ra
sw $ra, 0($sp)		# save return address to stack

jal init_matrix	# initialize the game board in memory
#########################################################
# For AJ: call your method to draw the matrix board here
#########################################################

play_one_game_loop:
jal get_input	# get input, loads the direction constant into $v0
move $s0, $v0	# move the return value to $s0

beq $s0, QUIT, quit_game	# if user chooses to quit, save score to scoreboard and end game

move $a0, $s0	# load the direction as a param for the move function
jal move_direction # loads the number of points from move into $v0
# STARTHERE (levi):  "pointsFromMove = mov.move(direction)" in the python




# TODO: figure when to jump back to top of while loop, and when/how to end program

quit_game:
li $v0, 0	# load 0 on $v0 to be returned (don't play again)
j end_play_one_game	 

end_play_one_game:
# destroy the stack frame; restore all from their offests
lw $ra, 0($sp)
addi $sp, $sp, 4  # move the stack pointer back up to where it was
jr $ra # return to caller


# ----------------- start_screen -----------------

# method: start_screen
    # print_start_menu()

    # while True:
    #     keyStroke = ik.get_key()

    #     match keyStroke:
    #         case "Z" | "z":
    #             return gd.START_GAME
    #         case "Q" | "q":
    #             return gd.QUIT_PROGRAM
    #         case "X" | "x":
    #             show_scores()
    #             print_start_menu()
    #         case "T" | "t":
    #             print("The theme has been changed to " + str(gd.theme) + " (*only visible in mips graphics)")
    #             change_theme()
start_screen:
addi $sp, $sp, -4	# allocate space on the stack for $ra
sw $ra, 0($sp)		# save return address to stack

####################################
# FOR AJ: build the start menu here!
####################################
#* call it in ss_x_pressed below too (or refactor/rearrange)

start_screen_while_loop:
jal get_key	# key the user hit is now stored in $v0

beq $v0, 122, ss_z_pressed	# key = 122 (ascii z)
beq $v0, 113, ss_q_pressed	# key = 113 (ascii q)
beq $v0, 120, ss_x_pressed	# key = 120 (ascii x)
beq $v0, 116, ss_t_pressed	# key = 116 (ascii t)
j start_screen_while_loop		# no valid key pressed, jump back to top of loop


ss_z_pressed:
# start game:
li $v0, START_GAME
j start_screen_end_loop


ss_q_pressed:
li $v0, QUIT_PROGRAM
j start_screen_end_loop


ss_x_pressed:
jal show_scores # navigate to the show_scores screen
# AJ: reprint the start menu here!
j start_screen_while_loop # jump back to top of while loop


ss_t_pressed:
jal change_theme	# toggle the theme
j start_screen_while_loop # jump back to top of while loop


start_screen_end_loop:
# destroy the stack frame; restore all from their offests
lw $ra, 0($sp)
addi $sp, $sp, 4  # move the stack pointer back up to where it was
jr $ra # return to caller



# method: change_theme
    # if gd.theme == 0:
    #     gd.theme = 1
    # elif gd.theme == 1:
    #     gd.theme = 0
change_theme:
# registers used:
# $t0 ---> address of the current theme
# $t1 ---> value of the current theme

la $t0, theme  # load address of current theme into $t0
lbu $t1, 0($t0) # load the value of the current theme into $t1

beq $t1, 0, toggleToOne	# if theme == 0, set to 1
# else (theme == 1), set theme to 0
sb $zero, 0($t0)
jr $ra 	# return to caller

toggleToOne:
li $t2, 1
sb $t2, 0($t0)
jr $ra 	# return to caller


# method: show_scores
show_scores:
addi $sp, $sp, -4	# allocate space on the stack for $ra
sw $ra, 0($sp)		# save return address to stack

########################################
# FOR AJ: build scoreboard screen here!
########################################


show_scores_while_loop:
jal get_key	# key the user hit is now stored in $v0

beq $v0, 120, show_scores_x_pressed	# key = 120 (ascii x)
j show_scores_while_loop		# no valid key pressed, jump back to top of loop


show_scores_x_pressed:
# destroy the stack frame; restore all from their offests
lw $ra, 0($sp)
addi $sp, $sp, 4  # move the stack pointer back up to where it was
jr $ra # return to caller


# ------------------ input_keys -------------------

# method get_input:
get_input:
addi $sp, $sp, -4	# allocate space on the stack for $ra
sw $ra, 0($sp)		# save return address to stack

get_input_while_loop:

jal get_key	# key the user hit is now stored in $v0

move $a0, $v0	# set 1st param $a0 to the key that was pressed
jal key_to_dir   # call key_to_dir(key), puts a direction constant in $v0

beq $v0, -1, get_input_while_loop # w a s or d was NOT pressed, loop again
# w a s or d WAS pressed, return direction constant (it is still loaded into $v0)

# destroy the stack frame; restore all from their offests
lw $ra, 0($sp)
addi $sp, $sp, 4  # move the stack pointer back up to where it was

jr $ra	# return


# method: get_key
# params: none
# returns a single character coorepsonding to the key that was pressed
get_key:
# Memory-Mapped I/O Addresses
# 0xFFFF0000 – Keyboard Control  (0 = no key, 1 = key pressed)
# 0xFFFF0004 – Keyboard Data     (ASCII value of key pressed)

lw   $t0, 0xFFFF0000($zero)     # load keyboard control register
andi $t0, $t0, 0x0001           # check if a key is available
beq  $t0, $zero, wait_key       # if not, keep looping

lw   $v0, 0xFFFF0004($zero)     # read ASCII value of key pressed. return it by putting it into $v0
jr $ra	# return to the caller


# method: key_to_dir
# params: $a0 --> the key pressed (ASCII value)
key_to_dir:
beq $a0, 119, w_pressed	# key = 119 (ascii w)
beq $a0, 97, a_pressed	# key = 97 (ascii a)
beq $a0, 115, s_pressed	# key = 115 (ascii s)
beq $a0, 100, d_pressed	# key = 100 (ascii d)

li $v0, -1	# key was not w, a, s, or d. return -1
jr $ra

w_pressed:
li $v0, UP	# return UP (2)
jr $ra

a_pressed:
li $v0, RIGHT	# return RIFHT
jr $ra

s_pressed:
li $v0, DOWN	# return DOWN
jr $ra

d_pressed:
li $v0, LEFT	# return LEFT
jr $ra



# method: wait_for_restart
# returns 1 if r is pressed and 0 if q is pressed
wait_for_restart:
addi $sp, $sp, -4	# allocate space on the stack for $ra
sw $ra, 0($sp)		# save return address to stack

wait_for_restart_while_loop:
jal get_key	# key the user hit is now stored in $v0

beq $v0, 114, r_pressed	# key = 114 (ascii r)
beq $v0, 113, q_pressed	# key = 113 (ascii q)

j wait_for_restart_while_loop # neither r nor q was pressed, jump back to top of loop

r_pressed:
li $v0, 1	# return True (1)
# destroy the stack frame; restore all from their offests
lw $ra, 0($sp)
addi $sp, $sp, 4  # move the stack pointer back up to where it was
jr $ra # return

q_pressed:
li $v0, 0	# return False (0)
# destroy the stack frame; restore all from their offests
lw $ra, 0($sp)
addi $sp, $sp, 4  # move the stack pointer back up to where it was
jr $ra # return








# ---------------------- display --------------------

# --- method: you_win ---
you_win:
# registers used:
# xyz

# TODO: fill out
# This method is for AJ!

jr $ra


# --- method: you_lose ---
you_lose:
# registers used:
# xyz

# TODO: fill out
# This method is for AJ!

jr $ra


# ---------------------- score ----------------------

# --- method: update_score ---
# update score, add points
# params: $a0 ---> int points
# return: void
update_score:
# registers used:
# $a0 ---> points to be added to score
# $s0 --> memory address of score
# $s1 ---> score value
la $s0, score		# get memory address of score
lw $s1, 0($s0)		# load value at memory address --> load the score value
add $s1, $s1, $a0	# add points to score ---> score value = score value + points value
sw $s1, 0($s0)		# store the updated score value back in memory
jr $ra			# jump back to caller


# ---------------------- score ----------------------

# --- method: update_score ---
# update score, add points
# params: $a0 ---> int points
# return: void
update_score:
# registers:
# $a0 ---> points to be added to score
# $t0 --> memory address of score
# $t1 ---> score value
la $t0, score		# get memory address of score
lw $t1, 0($t0)		# load value at memory address --> load the score value
add $t1, $t1, $a0	# add points to score ---> score value = score value + points value
sw $t1, 0($t0)		# store the updated score value back in memory
jr $ra			# jump back to caller



# --- method: add_high_score ---
# inserts the score value into high_scores, which must stay in sorterd order; the lowest drops off
# loops backwards and shifts values down until it finds the location to insert
# params: $a0 ---> int value, the score to be added to the scoreboard
# return: void
add_high_score:
# registers:
# $a0 ---> int score to be inserted
# $t0 --->  starting memory address of high_scores arr
# $t1 ---> i. starts as the 2nd to last value of high_scores
# $t2 ---> byte offset / address of high_scores[i]
# $t3 ---> value of high_scores[i]
# $t4 ---> i + 1, then address of high_scores[i + 1]
la $t0, high_scores	# get the starting memory address of the high_scores arr
li $t1, 3	# i = 3; put index of 2nd to last element (3) into i

lw $t3, 16($t0)		# load value of high_scores[4] into $t3
ble $a0, $t3, done_adding_high_score		# if the score is less than the lowsest highscore (high_scores[4] (4*4bytes = 16), then we don't need to add it. end

add_high_score_loop:
blt $t1, 0, insert_value	# while i >= 0. jumps out of loop when i<0

# if gd.high_scores[i] < score then shift down, else we are dont shifting so jump to insert_value
sll $t2, $t1, 2		# convert to byte offset - > $t2 = i * 4
add $t2, $t0, $t2	# compute address of high_scores[i] ---> $t2 = start address of high_scores + i
lw $t3, 0($t2)		# get value of high_scores[i] into $t3

bge $t3, $a0, insert_value		# if high_scores[i] >= score, then we found where to insert the value
# otherwise shift down and decrement i:
sw $t3, 4($t2)		# high_scores[i + 1] = high_scores[i]
addi $t1, $t1, -1	# i -=1
j add_high_score_loop	# jump back to top of loop

insert_value:
# insert score into high_scores[i + 1]
addi $t4, $t1, 1		# calculate i + 1
sll $t4, $t4, 2		# convert to byte offset --> (i + 1) * 4
add $t4, $t4, $t0	# get address of high_scores[i + 1]

sw $a0, 0($t4)		# set high_scores[i + 1] to score in memory!!!

done_adding_high_score:
jr $ra		# jump back to caller