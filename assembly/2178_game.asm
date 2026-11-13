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








# ---------------------- score ----------------------

# --- method: update_score ---
# update score, add points
# params: $a0 ---> int points
# return: void
update_score:
# registers:
# $a0 ---> points to be added to score
# $s0 --> memory address of score
# $s1 ---> score value
la $s0, score		# get memory address of score
lw $s1, 0($s0)		# load value at memory address --> load the score value
add $s1, $s1, $a0		# add points to score ---> score value = score value + points value
sw $s1, 0($s0)		# store the updated score value back in memory
jr $ra			# jump back to caller



# --- method: add_high_score ---
# inserts the score value into high_scores, which must stay in sorterd order; the lowest drops off
# loops backwards and shifts values down until it finds the location to insert
# params: $a0 ---> int value, the score to be added to the scoreboard
# return: void
add_high_score:
# registers:
# $a0 ---> int score to be inserted
# $s0 --->  starting memory address of high_scores arr
# $s1 ---> i. starts as the 2nd to last value of high_scores
# $s2 ---> address of high_scores[i]
# $s3 ---> value of high_scores[i]
# $s4 ---> i + 1, then address of high_scores[i + 1]
# $s5 ---> address of high_scores[i + 1]
la $s0, high_scores	# get the starting memory address of the high_scores arr
li $s1, 3	# i = 3; put index of 2nd to last element (3) into i

bgt $a0, 4($s0) needToAdd		# if the score is less than the lowsest highscore, then we don't need to add it. end
j done_adding_high_score

needToAdd:
blt $s1, 0, insert_value	# while i >= 0. jumps out of loop when i<0

# if gd.high_scores[i] < score then shift down, else we are dont shifting so jump to insert_value
add $s2, $s0, $s1	# compute address of high_scores[i] ---> $s2 = start address of high_scores + i
lw $s3, 0($s2)		# get value of high_scores[i] into $s3

bge $s3, $s0 insert_value		# if high_scores[i] >= score, then we found where to insert the value
# otherwise shift down and decrement i:
addi $s4, $s1, 1		# calculate i + 1
addi $s4, $s4, $s0	# get address of high_scores[i + 1]
sw $s3, 0($s4)	# set high_scores[i + 1] as highscores[i] (this is in $s3) in memory

addi $s1, $s1 -1		# decrement i: i -= 1 
j needToAdd 	# jump back to top of while loop

insert_value:
# insert score into high_scores[i + 1]
addi $s4, $s1, 1		# calculate i + 1
addi $s4, $s4, $s0	# get address of high_scores[i + 1]

sw $a0, 0($s4)		# set high_scores[i + 1] to score in memory!!!

done_adding_high_score:
jr $ra		# jump back to caller
	
# STARTHEREL: fix bugs in add_high_score (see claude) and feed it back again to ensure correct