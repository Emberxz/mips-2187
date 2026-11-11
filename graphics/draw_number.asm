# draw_number
# Draws a number like 2187 using draw_char
# $a0 = x $a1 = y $a2 = the number $a3 = scale $t0 = color
draw_number:
    addi $sp,$sp,-24
    sw $ra,20($sp)
    sw $s0,0($sp)
    sw $s1,4($sp)
    sw $s2,8($sp)
    sw $s3,12($sp)
    sw $s4,16($sp)

    move $s0,$a0          # s0 = x of the next digit
    move $s1,$a1          # s1 = y
    move $s3,$a3          # s3 = scale
    li $s2,0              # s2 = how many digits so far
    move $t6,$a2          # t6 = what is left of the number
    li $t7,10

    # split takes off the last digit until nothing is left
dn_split:
    div $t6,$t7           # number / 10
    mfhi $t8              # remainder = last digit
    mflo $t6              # quotient = the rest of the number
    addi $t8,$t8,48       # digit to ASCII just add 48 to it cause 0 is 48
    la $t5,numBuf
    add $t5,$t5,$s2
    sb $t8,0($t5)         # store it in numBuf (its kinda jank they get added in reverse so 2187 is added as 7812)
    addi $s2,$s2,1
    bne $t6,$zero,dn_split

    # draw go through numBuf from the end back to the start
    move $s4,$s2          # s4 = digits left to draw
dn_draw:
    addi $s4,$s4,-1
    bltz $s4,dn_done      # nums left is < 0
    la $t5,numBuf
    add $t5,$t5,$s4
    lbu $a2,0($t5)        # the digit ASCII code
    move $a0,$s0
    move $a1,$s1
    move $a3,$s3
    jal draw_char
    sll $t6,$s3,2         # x += 4 * scale
    add $s0,$s0,$t6
    j dn_draw

dn_done:
    lw $ra,20($sp)
    lw $s0,0($sp)
    lw $s1,4($sp)
    lw $s2,8($sp)
    lw $s3,12($sp)
    lw $s4,16($sp)
    addi $sp,$sp,24
    jr $ra
