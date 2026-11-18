# print_matrix
# Draws all 16 tiles from the matrix It only reads in the matrix output from the team
# matrix is 16 words row by row cell (row, col) is word row*4 + col
print_matrix:
    addi $sp,$sp,-8
    sw $ra,4($sp)
    sw $s0,0($sp)

    li $s0,0              # s0 = cell number 0-15
pm_loop:
    la $t5,matrix
    sll $t6,$s0,2         # cell * 4 cell = a word
    add $t5,$t5,$t6
    lw $a2,0($t5)         # a2 = exponent in this cell
    srl $a0,$s0,2         # a0 = row = cell / 4
    andi $a1,$s0,3        # a1 = col = cell % 4
    jal draw_tile
    addi $s0,$s0,1
    blt $s0,16,pm_loop    # 4x4 so 16 checks in total

    lw $ra,4($sp)
    lw $s0,0($sp)
    addi $sp,$sp,8
    jr $ra
