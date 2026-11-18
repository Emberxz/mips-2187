# draw_title_screen, you_win and you_lose

# draw_title_screen

# you_win
# Pops up the green you win window over the board
you_win:
    la $a0,str_win        # title
    li $a1,216            # centering title (256 - 81/2)
    li $a2,0x004E8020     # sets it to green
    j draw_popup          # draw_popup's jr $ra goes straight back to whoever called you_win

# you_lose
# Pops up the red you lose window over the board
you_lose:
    la $a0,str_lose       # title
    li $a1,210            # centering title (256 - 93/2)
    li $a2,0x00B22222     # sets it to red
    j draw_popup

# draw_popup
# The window both screens share a 160x96 box in the middle of the game area
# has a white border the title the final score and the R / Q keys
# $a0 = address of the title string $a1 = title x $a2 = window color
draw_popup:
    addi $sp,$sp,-12
    sw $ra,8($sp)
    sw $s0,0($sp)
    sw $s1,4($sp)
    move $s0,$a0          # s0 = title string
    move $s1,$a1          # s1 = title x

    # window background
    move $t0,$a2
    li $a0,176
    li $a1,160
    li $a2,40
    li $a3,96
    jal rectangle

    # white border
    li $t0,0x00FFFFFF
    li $a0,176
    li $a1,160
    li $a2,40
    li $a3,96
    jal draw_box

    # title at scale 3
    move $a0,$s1
    li $a1,52
    move $a2,$s0
    li $a3,3
    jal draw_text

    # SCORE and the final score (may have to change this centering idk what the scores are gonna be)
    li $a0,214
    li $a1,82
    la $a2,str_score
    li $a3,2
    jal draw_text
    li $a0,260            # SCORE is 38 wide + 8 gap
    li $a1,82
    lw $a2,score
    li $a3,2
    jal draw_number

    # R and Q instructions
    li $a0,221            # centered (256 - 70/2)
    li $a1,104
    la $a2,str_rst
    li $a3,2
    jal draw_text
    li $a0,233            # centered (256 - 46/2)
    li $a1,118
    la $a2,str_quit
    li $a3,2
    jal draw_text

    lw $ra,8($sp)
    lw $s0,0($sp)
    lw $s1,4($sp)
    addi $sp,$sp,12
    jr $ra
