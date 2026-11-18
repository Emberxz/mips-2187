# draw_tile and get_color

# draw_tile
# Draws one tile the colored square plus the number in the middle
# $a0 = row (0-3) $a1 = col (0-3) $a2 = exponent (0 = empty, 7 = 2187)
# The tile is 51x31 at x = 147 + col*55, y = 19 + row*35
draw_tile:
    addi $sp,$sp,-16
    sw $ra,12($sp)
    sw $s0,0($sp)
    sw $s1,4($sp)
    sw $s2,8($sp)

    # where the tile goes on screen
    li $t5,55
    mul $s0,$a1,$t5
    addi $s0,$s0,147      # s0 = tile x = 147 + col*55
    li $t5,35
    mul $s1,$a0,$t5
    addi $s1,$s1,19       # s1 = tile y = 19 + row*35
    move $s2,$a2          # s2 = exponent

    # the colored square (just paints over the old numbers)
    move $a0,$s2
    jal get_color         # v0 = color for this exponent
    move $t0,$v0
    move $a0,$s0
    li $a1,51
    move $a2,$s1
    li $a3,31
    jal rectangle

    beq $s2,$zero,dtile_done   # empty tile that has no number

    # text color dark on the light 3 and 9 tiles, white on the rest
    li $t0,0x00FFFFFF
    bgt $s2,2,dtile_num
    li $t0,0x00222222
dtile_num:
    sll $t6,$s2,2         # exponent * 4
    la $t5,tileTextX
    add $t5,$t5,$t6
    lw $t7,0($t5)
    add $a0,$s0,$t7       # x = tile x + offset to center it
    la $t5,pow3
    add $t5,$t5,$t6
    lw $a2,0($t5)         # the real value, like 2187

    # size scale 3 for up to 4 digits (exponents 1-8)
    # scale 2 for the 5 and 6 digit tiles (exponents 9-11)
    li $a3,3              # scale 3 = 9x15 digits
    addi $a1,$s1,8        # y = tile y + (31 - 15) / 2
    ble $s2,8,dtile_draw
    li $a3,2              # scale 2 = 6x10 digits
    addi $a1,$s1,10       # y = tile y + (31 - 10) / 2
dtile_draw:
    jal draw_number

dtile_done:
    lw $ra,12($sp)
    lw $s0,0($sp)
    lw $s1,4($sp)
    lw $s2,8($sp)
    addi $sp,$sp,16
    jr $ra

# get_color
# $a0 = exponent returns $v0 = the tile color for it
# later this is where the theme can pick a different color table
get_color:
    sll $t5,$a0,2         # exponent * 4
    la $t6,tileColors
    add $t6,$t6,$t5
    lw $v0,0($t6)
    jr $ra
