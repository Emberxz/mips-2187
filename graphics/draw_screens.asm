# draw_title_screen, you_win and you_lose

# draw_title_screen
# The start screen
# a big 2187 with a shadow behind it(ist just moved down and 3 pixel and grey) and PRESS Z under it.
draw_title_screen:
    addi $sp,$sp,-4
    sw $ra,0($sp)

    # background covers the whole 512x256 display
    jal get_theme
    lw $t0,0($v0)         # background color
    li $a0,0
    li $a1,512
    li $a2,0
    li $a3,256
    jal rectangle

    jal draw_frame
    jal draw_controls

    # shadow the same 2187 3 pixels right and 3 down in grey
    li $t0,0x008591A0
    li $a0,214
    li $a1,61
    la $a2,str_title
    li $a3,6              # scale 6 = 18x30 digits
    jal draw_text

    # 2187 shadow in the themes game color
    jal get_theme
    lw $t0,4($v0)
    li $a0,211            # centered (256 - 90/2)
    li $a1,58
    la $a2,str_title
    li $a3,6
    jal draw_text

    # PRESS Z
    li $t0,0x00E86100     # sets orange
    li $a0,229            # centered (256 - 54/2)
    li $a1,118
    la $a2,str_pressz
    li $a3,2
    jal draw_text

    lw $ra,0($sp)
    addi $sp,$sp,4
    jr $ra

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

# draw_high_scores
# Pops up the scoreboard window with the top 5 from high_scores
# Empty slots are 0 so they just show 0
draw_high_scores:
    addi $sp,$sp,-12
    sw $ra,8($sp)
    sw $s0,0($sp)
    sw $s1,4($sp)

    # window background (same as the win/lose)
    li $t0,0x003A6EA5     # blue
    li $a0,166
    li $a1,180
    li $a2,20
    li $a3,136
    jal rectangle

    # white border
    li $t0,0x00FFFFFF
    li $a0,166
    li $a1,180
    li $a2,20
    li $a3,136
    jal draw_box

    # title
    li $a0,213            # centered (256 - 86/2)
    li $a1,30
    la $a2,str_hiscores
    li $a3,2
    jal draw_text

    # the 5 rows rank on the left and the score next to it
    li $s0,0              # s0 = row 0-4
    li $s1,50             # s1 = y of the row, 16 pixels apart
dhs_loop:
    li $a0,196
    move $a1,$s1
    addi $a2,$s0,49       # rank as a character '1' is 49
    li $a3,2
    jal draw_char

    sll $t6,$s0,2         # row * 4
    la $t5,high_scores
    add $t5,$t5,$t6
    lw $a2,0($t5)         # this rows score
    li $a0,226
    move $a1,$s1
    li $a3,2
    jal draw_number

    addi $s1,$s1,16       # next row down
    addi $s0,$s0,1
    blt $s0,5,dhs_loop    # 5 rows

    # how to close it
    li $a0,229            # centered (256 - 54/2)
    li $a1,138
    la $a2,str_close
    li $a3,2
    jal draw_text

    lw $ra,8($sp)
    lw $s0,0($sp)
    lw $s1,4($sp)
    addi $sp,$sp,12
    jr $ra
