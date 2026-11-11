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