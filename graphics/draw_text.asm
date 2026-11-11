# text: draw_char and draw_text

# draw_char
# Draws one character from the font table.
# $a0 = x (left edge) $a1 = y (top edge)
# $a2 = the characters ascii number from .asciiz
# $a3 = scale (how many pixels wide each cell is)
# $t0 = color
# I haven't tested yet I need to make draw text and draw_controls 
draw_char:
    # save registers: rectangle changes $a0-$a3 and jal changes $ra
    addi $sp,$sp,-32
    sw $ra,28($sp)
    sw $s0,0($sp)
    sw $s1,4($sp)
    sw $s2,8($sp)
    sw $s3,12($sp)
    sw $s4,16($sp)
    sw $s5,20($sp)
    sw $s6,24($sp)

    move $s0,$a0          # s0 = left edge x
    move $s1,$a1          # s1 = y of the row being drawn
    move $s3,$a3          # s3 = scale

    # for the spaces 
    li $t5,' '
    beq $a2,$t5,dc_done

    # turns the ASCII code into the font index we need
    # we need to subtract from the index so that the ascii matches our indexes becuase
    # there is a gap between nums and letters in normal ascii
    # ascii goes ...'9'  ':' ';' '<' '=' '>' '?' '@' 'A'...
    li $t5,'A'
    blt $a2,$t5,dc_digit  # < A is a digit
    addi $t6,$a2,-55      # Example for letters 'A' (65) - 55 = 10
    j dc_load
dc_digit:
    addi $t6,$a2,-48      # Example for digit '0' (48) - 48 = 0

    # getting the glyph its font + index*4
dc_load:
    sll $t6,$t6,2         # index * 4 
    la $t5,font
    add $t5,$t5,$t6
    lw $s2,0($t5)         # s2 = the 15 bits for shapes

    li $s5,5              # rows left to draw
dc_row:
    move $s4,$s0          # s4 = x of the cell back to the left edge
    li $s6,3              # number of columns left to draw in this line
dc_cell:
    andi $t5,$s2,0x4000   # look at bit 14
    beq $t5,$zero,dc_next # if 0 = cell then the cell is off so just skip it
    move $a0,$s4          # x
    move $a1,$s3          # width = scale
    move $a2,$s1          # y
    move $a3,$s3          # height = scale
    jal rectangle         # paint the cell
dc_next:
    sll $s2,$s2,1         # shift so the next cell is in bit 14
    add $s4,$s4,$s3       # move right one cell
    addi $s6,$s6,-1
    bne $s6,$zero,dc_cell # more cells in this row
    add $s1,$s1,$s3       # move down one row
    addi $s5,$s5,-1
    bne $s5,$zero,dc_row  # more rows

dc_done:
    # restore registers the registers for other stuff
    lw $ra,28($sp)
    lw $s0,0($sp)
    lw $s1,4($sp)
    lw $s2,8($sp)
    lw $s3,12($sp)
    lw $s4,16($sp)
    lw $s5,20($sp)
    lw $s6,24($sp)
    addi $sp,$sp,32
    jr $ra

# draw_text
# Draws a string one character at a time by calling draw_char.
# $a0 = x, $a1 = y, $a2 = address of the string, $a3 = scale
# $t0 = color
draw_text:
    # save $ra (jal draw_char overwrites it) and the $s registers we use
    addi $sp,$sp,-20
    sw $ra,16($sp)
    sw $s0,0($sp)
    sw $s1,4($sp)
    sw $s2,8($sp)
    sw $s3,12($sp)

    move $s0,$a0          # s0 = x of the next character
    move $s1,$a1          # s1 = y
    move $s2,$a2          # s2 = address of the next character
    move $s3,$a3          # s3 = scale
dt_loop:
    lbu $t5,0($s2)        # load one byte (one character)
    beq $t5,$zero,dt_done # 0 = end of the .asciiz string
    move $a0,$s0
    move $a1,$s1
    move $a2,$t5          # the character's ASCII code
    move $a3,$s3
    jal draw_char
    sll $t6,$s3,2         # 4 * scale = 3 cells of glyph + 1 cell gap
    add $s0,$s0,$t6       # move x right to the next character
    addi $s2,$s2,1        # next byte in the string
    j dt_loop
dt_done:
    lw $ra,16($sp)
    lw $s0,0($sp)
    lw $s1,4($sp)
    lw $s2,8($sp)
    lw $s3,12($sp)
    addi $sp,$sp,20
    jr $ra

