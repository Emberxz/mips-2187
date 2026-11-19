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
# $s1 ---> pointsFromMove
# $s2 ---> gameState (WIN, LOSS, or CONTINUE)

addi $sp, $sp, -16	# allocate space on the stack for $ra and s registers
sw $ra, 12($sp)		# save return address to stack
sw $s0, 8($sp)
sw $s1, 4($sp)
sw $s2, 0($sp)

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
move $s1, $v0	  # move the returned value (pointsFromMove) into $s1

jal check_mat	# check the matrix to see if you've won/lost 
move $s2, $v0	# move returned value (gameState) into $s2

beq $s2, LOSS, you_lost	# if gameState == LOSS --> jump to you_lost; if you've lost, end the game
beq $s1, -1, play_one_game_loop # if pointsFromMove == -1; you didn't lose, but move was invalid, just jump back to top of loop to get new direction input
# if we've gotten here, move was valid

# update the score:
move $a0, $s1 	# load pointsFromMove into $a0 to act as param for update_score
jal update_score # call update_score(pointsFromMove)

# check whether or not you've won:
beq $s2, WIN, you_won

# if we've gotten here, gameState isn't LOSS or WIN, must be CONTINUE
jal spawn_tile	# add a new tile to board
##########################################
# For AJ. draw the matrix again here!
##########################################

j play_one_game_loop # jump back to top of loop

you_lost:
jal you_lose	# draw lose screen
j game_over_logic


you_won:
jal you_win	# draw win screen
j game_over_logic

game_over_logic:
# update the highscores array
la $a0, score 	# get address of score
lw $a0, 0($a0) 	# load current score from memory into $a0 to act as param for add_high_score 
jal add_high_score # call add_high_score(score)

jal wait_for_restart 	# wait for user to restart or quit
# wait_for_restart loads the key command into $v0, return this for play_one_game; simply need to end play_one_game:
j end_play_one_game 


quit_game:
# update the highscores array
la $a0, score 	# get address of score
lw $a0, 0($a0) 	# load current score from memory into $a0 to act as param for add_high_score 
jal add_high_score # call add_high_score(score)

li $v0, 0	# load 0 on $v0 to be returned (don't play again)
j end_play_one_game	 

end_play_one_game:
# destroy the stack frame; restore all from their offests
lw $ra, 12($sp)
lw $s0, 8($sp)
lw $s1, 4($sp)
lw $s2, 0($sp)
addi $sp, $sp, 16  # move the stack pointer back up to where it was
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

# int slide_merge_line(int line[4])
# returns: points if a move was made and -1 if no move was made
# $a0 = int line[4]
slide_merge_line:
# save $s0, $s1 to the stack
addiu $sp, $sp, -12
sw $ra, 8($sp)
sw $s0, 4($sp)
sw $s1, 0($sp)

move $s0, $zero		# $s0 = did_work = 0

jal compress_line	# compress_line(line)
or $s0, $s0, $v0	# did_work |= compress_line(line)

jal merge_line		# merge_line(line)
or $s0, $s0, $v0	# did_work |= merge_line(line)
move $s1, $v0		# $s1 = points = merge_line(line)

jal compress_line	# compress_line(line)
or $s0, $s0, $v0	# did_work |= compress_line(line)

move $v0, $s1		# $v0 = points
bgt $s0, $zero, slide_merge_line_return	# if (did_work > 0) -> slide_merge_line_return
li $v0, -1		# $v0 = -1

slide_merge_line_return:
# pop saved values from the stack
lw $ra, 8($sp)
lw $s0, 4($sp)
lw $s1, 0($sp)
addiu $sp, $sp, 12

jr $ra








# bool compress_line(int line[4])
# returns: whether the line was compressed
compress_line:
# save used registers
addiu $sp, $sp, -28
sw $s6, 0($sp)
sw $s5, 4($sp)
sw $s4, 8($sp)
sw $s3, 12($sp)
sw $s2, 16($sp)
sw $s1, 20($sp)
sw $s0, 24($sp)

move $s0, $zero		# $s0 = did_compress = 0
move $s1, $zero		# $s1 = i = 0

compress_outer_loop:
bgt $s1, 3, compress_outer_loop_done	# if (i > 3) -> compress_outer_loop_done
move $s2, $s1		# $s2 = j = i

compress_inner_loop:
ble $s2, 0, compress_inner_loop_done	# if (j <= 0) -> compress_inner_loop_done

# $s3 = &line[j]
sll $s3, $s2, 2
addu $s3, $s3, $a0

# $s4 = line[j]
lw $s4, 0($s3)

# $s5 = &line[j - 1]
addiu $s5, $s2, -1
sll $s5, $s5, 2
addu $s5, $s5, $a0

# $s6 = line[j - 1]
lw $s6, 0($s5)

beq $s4, 0, compress_inner_loop_done	# if (line[j] == 0) -> compress_inner_loop_done
bne $s6, 0, compress_inner_loop_done	# if (line[j - 1] != 0) -> compress_inner_loop_done

sw $s4, 0($s5)		# line[j - 1] = line[j]
sw $zero, 0($s3)	# line[j] = 0
li $s0, 1		# did_compress = 1
addiu $s2, $s2, -1	# j--

j compress_inner_loop

compress_inner_loop_done:
addiu $s1, $s1, 1	# i++
j compress_outer_loop

compress_outer_loop_done:
# return did_compress
move $v0, $s0

# restore used registers
lw $s0, 24($sp)
lw $s1, 20($sp)
lw $s2, 16($sp)
lw $s3, 12($sp)
lw $s4, 8($sp)
lw $s5, 4($sp)
lw $s6, 0($sp)
addiu $sp, $sp, 28

jr $ra

# int merge_line(int line[4])
# returns: the points from the merge
merge_line:
# save used registers
addiu $sp, $sp, -28
sw $s6, 0($sp)
sw $s5, 4($sp)
sw $s4, 8($sp)
sw $s3, 12($sp)
sw $s2, 16($sp)
sw $s1, 20($sp)
sw $s0, 24($sp)

move $s0, $zero		# $s0 = points = 0
move $s1, $zero		# $s1 = i = 0

merge_loop:
bge $s1, 3, merge_loop_done		# if (i >= 3) -> merge_loop_done

# $s2 = &line[i]
sll $s2, $s1, 2
addu $s2, $s2, $a0

# $s3 = line[i]
lw $s3, 0($s2)

# $s4 = &line[i + 1]
addiu $s4, $s1, 1
sll $s4, $s4, 2
addu $s4, $s4, $a0

# $s5 = line[i + 1]
lw $s5, 0($s4)

beq $s3, 0, merge_loop_continue		# if (line[i] == 0) -> merge_loop_continue
bne $s3, $s5, merge_loop_continue	# if (line[i] != line[i + 1]) -> merge_loop_continue

addiu $s5, $s5, 1	# line[i + 1]++
move $s3, $zero		# line[i] = 0

sw $s5, 0($s4)
sw $s3, 0($s2)

# increment points
la $t0, pow3        # $t0 = &pow3
move $t1, $zero     # $t1 = 0 = offset into pow3
sll $t1, $t1, $s5   # $t1 = line[i + 1] * 4
addu $t0, $t0, $t1  # $t0 = &pow3[line[i + 1]]
lw $t1, 0($t0)      # $t1 = pow3[line[i + 1]]
addu $s0, $s0, $t1  # $s0 += pow3[line[i + 1]]

addiu $s1, $s1, 1	# i++

merge_loop_continue:
addiu $s1, $s1, 1	# i++
j merge_loop

merge_loop_done:
# return points
move $v0, $s0

# restore used registers
lw $s0, 24($sp)
lw $s1, 20($sp)
lw $s2, 16($sp)
lw $s3, 12($sp)
lw $s4, 8($sp)
lw $s5, 4($sp)
lw $s6, 0($sp)
addiu $sp, $sp, 28

jr $ra


#Caleb's methods
#check_mat.py methods
# ----------- check_mat.py ------------

#def has_177147():
#    #checks if any cell has value 2187, returns true/false
#    for i in range(16):
#        if gd.matrix[i] == gd.WIN_EXP:
#            return True
#    return False
#checks if any cell has value 2187, returns true/false


has_177147:
	la $t0, matrix #starting address of matrix
	li $t1, 0 #i=0
	li $t4, WIN_EXP #$t4 = win condition exponent
	
has_177147_loop:
	bge $t1, 16, has_177147_false #check if finished checked all cells
	
	sll $t2, $t1, 2
	addu $t2, $t0, $t2
	lw $t3, 0($t2)
	
	beq $t3, $t4, has_177147_true #true if current cell = 177147
	
	addiu $t1, $t1, 1
	j has_177147_loop #iterate to next cell
	
has_177147_false:
	li $v0, 0
	jr $ra


has_177147_true:
	li $v0, 1
	jr $ra
	
#can_move()
#def can_move():
#    #checks if there are any possible moves / hasn't loss
#   #returns true if any cell is 0 or if anything can still be merged
#    for i in range(16):
#        if gd.matrix[i] == 0:
#            return True
#        #checking right neighbors, not checking last column since it doesn't have a right neighbor
#        if i % 4 < 3:
#           if gd.matrix[i] == gd.matrix[i+1]:
#                return True    
#        
#        #checking below neighbors, not checking bottom column since it doesn't have a below neighbor
#        if i < 12:
#            if gd.matrix[i] == gd.matrix[i+4]:
#                return True
#    
#    #dont need to check left or above neighbors as it would be overlapping these checks
#    return False	
	
can_move:
	la $t0, matrix
	li $t1, 0
	
can_move_loop:
	bge $t1, 16, can_move_false #if all cells checked 
	
	sll $t2, $t1, 2
	addu $t2, $t0, $t2  #initialize matrix
	lw $t3, 0($t2)
	
	
	beq $t3, $zero, can_move_true #check for empty cell
	
	andi $t4, $t1, 3
	beq $t4, 3, can_move_check_down #skip right check if last column
	
	lw $t5, 4($t2)
	beq $t3, $t5, can_move_true
	
	
can_move_check_down:
	bge $t1, 12, can_move_next #skip if last row
	lw $t5, 16($t2)
	beq $t3, $t5, can_move_true

can_move_next:
	addiu $t1, $t1, 1
	j can_move_loop
	
can_move_false:
	li $v0, 0
	jr $ra

can_move_true:
	li $v0, 1
	jr $ra


#check_mat()

#def check_mat():
#    #checks the matrix if win/loss/ possible moves
#    if has_177147():
#        return gd.WIN
#    if not can_move():
#        return gd.LOSS
#    return gd.CONTINUE
    

check_mat:
	addiu $sp, $sp, -4 #allocate stack space
	sw $ra, 0($sp)
	
	jal has_177147
	bne $v0, $zero, check_mat_win #$v0 = true (1) or false (0) true returns WIN
	
	jal can_move
	beq $v0, $zero, check_mat_loss # false returns LOSS
	
	li $v0, CONTINUE #else, return CONTINUE
	j check_mat_end

check_mat_win:
	li $v0, WIN
	j check_mat_end

check_mat_loss:
	li $v0, LOSS

check_mat_end:
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra
	
	
# --------- Matrix.py ---------

#def count_empty():
#    #counts numbers of cells equal to 0
#    #returns int
#    count = 0
#    for i in range(0,16):
#        if gd.matrix[i] == 0:
#            count += 1
#
#    return count 

count_empty: 
	la $t0, matrix
	li $t1, 0
	li $v0, 0

count_empty_loop:
	bge $t1, 16, count_empty_end 
	
	sll $t2, $t1, 2
	addu $t2, $t0, $t2   #literally just looping through the matrix and 
	lw $t3, 0($t2)
	
	bne $t3, $zero, count_empty_next 
	addiu $v0, $v0, 1

count_empty_next:
	addiu $t1, $t1, 1
	j count_empty_loop

count_empty_end:
	jr $ra

# rand_range()

#def rand_range(n):
#    #returns a random number 0 - n-1    
#    rng = random.randrange(n)
#
#    return rng

rand_range:
	move $a1, $a0
	li $a0, 0
	li $v0, 42
	syscall
	
	move $v0, $a0
	jr $ra
	
#spawn_tile()


#def spawn_tile():
#    #spawns a new tile equal to either 3 or 9, spawns a 3 9/10 times
#    n = count_empty()
#    #returns if there are no empty spots
#    if n == 0:
#        return
#    
#    kth_empty = rand_range(n)
#    empty_count = 0
#    new_tile_index = -1
#    for i in range(0,16):
#        if gd.matrix[i] == 0:
#            if empty_count == kth_empty:
#                new_tile_index = i
#                break
#            empty_count += 1
#    
#    #calulate if we insert a 3 or a 9
#    if rand_range(10) < 9:
#        gd.matrix[new_tile_index] = 1
#    else:
#        gd.matrix[new_tile_index] = 2	

spawn_tile:
	addiu $sp, $sp, -8
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	
	jal count_empty
	beq $v0, $zero, spawn_tile_end
	
	move $a0, $v0
	jal rand_range
	move $t4, $v0
	
	la $t0, matrix
	li $t1, 0
	li $t5, 0
	

spawn_tile_loop:
	bge $t1, 16, spawn_tile_end
	
	sll $t2, $t1, 2
	addu $t2, $t0, $t2
	lw $t3, 0($t2)
	
	bne $t3, $zero, spawn_tile_next
	beq $t5, $t4, spawn_tile_found
	
	addiu $t5, $t5, 1

spawn_tile_next:
	addiu $t1, $t1, 1
	j spawn_tile_loop


spawn_tile_found:
	move $s0, $t2
	
	li $a0, 10 # calling rand_range with 10 so we get random number 0-9
	jal rand_range
	
	li $t3, 1
	blt $v0, 9, spawn_tile_store #if random num is 9, we use exponent 2
	
	li $t3, 2 


spawn_tile_store:
	sw $t3, 0($s0)


spawn_tile_end:
	lw $s0, 0($sp)
	lw $ra, 4($sp)
	addiu $sp, $sp, 8
	jr $ra

#init_matrix()

#def init_matrix():
#    #should intialize the beginning matrix for the game
#    #sets score to 0
#    #calls spawn_tile() twice
#    #returns nothing
#    gd.matrix = [0] * 16
#    gd.score = 0
#    spawn_tile()
#    spawn_tile()


init_matrix:
	addiu $sp, $sp, -8
	sw $ra, 4($sp)
	
	la $t0, matrix
	li $t1, 0
	

init_matrix_loop:
	bge $t1, 16, init_matrix_spawn
	
	sll $t2, $t1, 2
	addu $t2, $t0, $t2
	sw $zero, 0($t2)
	
	addiu $t1, $t1, 1
	j init_matrix_loop


init_matrix_spawn:
	la $t0, score
	sw $zero, 0($t0)
	
	jal spawn_tile
	jal spawn_tile
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 8
	jr $ra

