# controls: the labels under the gameboard

# draw_controls
# Draws the grey divider and the 9 control labels under the gameboard.
# Left column x=146, right column x=272, lines 14 pixels apart, scale 2
draw_controls:
    addi $sp,$sp,-4
    sw $ra,0($sp)

    # grey divider between the two columns
    li $t0,0x00888888
    li $a0,262
    li $a1,2
    li $a2,172
    li $a3,70
    jal rectangle

    li $t0,0x00FFFFFF     # white text

    # left column: movement keys
    li $a0,146
    li $a1,176
    la $a2,str_up
    li $a3,2
    jal draw_text
    li $a0,146
    li $a1,190
    la $a2,str_left
    li $a3,2
    jal draw_text
    li $a0,146
    li $a1,204
    la $a2,str_down
    li $a3,2
    jal draw_text
    li $a0,146
    li $a1,218
    la $a2,str_right
    li $a3,2
    jal draw_text

    # right column: game keys
    li $a0,272
    li $a1,176
    la $a2,str_rst
    li $a3,2
    jal draw_text
    li $a0,272
    li $a1,190
    la $a2,str_quit
    li $a3,2
    jal draw_text
    li $a0,272
    li $a1,204
    la $a2,str_theme
    li $a3,2
    jal draw_text
    li $a0,272
    li $a1,218
    la $a2,str_start
    li $a3,2
    jal draw_text
    li $a0,272
    li $a1,232
    la $a2,str_scores
    li $a3,2
    jal draw_text

    lw $ra,0($sp)
    addi $sp,$sp,4
    jr $ra

