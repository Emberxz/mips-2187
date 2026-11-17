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
WIN_EXP: .`word 11
LEFT: .word 0
RIGHT: .word 1
UP: .word 2
DOWN: .word 3

QUIT_PROGRAM: .word -3
QUIT: .word -2
CONTINUE: .word 0
WIN: .word 1
LOSS: .word 2
START_GAME: .word 3


# ------- All game logic goes here -------
.text

# main game loop
main:

jr $ra





# ------------------ input_keys -------------------

get_input:

jr $ra


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
# params: $a0 --> the key
# 
key_to_dir:
# registers used:
# 

jr $ra



wait_for_restart:

jr $ra






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