# draw_scoreboard
# Draws SCORE and the current score to the right of the outer box
draw_scoreboard:
    addi $sp,$sp,-8
    sw $ra,4($sp)
    sw $s0,0($sp)

    jal get_theme
    move $s0,$v0          # s0 = this theme's colors

    # cover the old number with the game color first
    # or the new digits draw on top of the old ones
    # 112 wide fits 9 digits at scale 3
    lw $t0,0($s0)         # game color
    li $a0,396
    li $a1,112
    li $a2,32
    li $a3,15
    jal rectangle

    # label
    lw $t0,4($s0)         # game color
    li $a0,396
    li $a1,16
    la $a2,str_score
    li $a3,2
    jal draw_text

    # the number
    li $a0,396
    li $a1,32
    lw $a2,score
    li $a3,3              # scale 3 = 9x15 digits
    jal draw_number

    lw $ra,4($sp)
    lw $s0,0($sp)
    addi $sp,$sp,8
    jr $ra
