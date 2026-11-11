# basic shapes: draw_box and rectangle

# draw_box
# Draws the outline of a box as four filled rectangles and the BORDER pixels sets thinckness.
# $a0 is x1 left, $a1 is width, $a2 is y1 top, $a3 is height
# $t0 is the color, rectangle never changes $t0 beacuse it stays set for all 4 sides
draw_box:
    addi $sp,$sp,-20
    sw $ra,16($sp)
    sw $a0,0($sp)
    sw $a1,4($sp)
    sw $a2,8($sp)
    sw $a3,12($sp)

    # top
    li $a3,BORDER
    jal rectangle

    # bottom 
    lw $a0,0($sp)
    lw $a1,4($sp)
    lw $a2,8($sp)
    lw $t5,12($sp)
    add $a2,$a2,$t5   # y1 + height
    addi $a2,$a2,-BORDER   # move up by the border thickness
    li $a3,BORDER
    jal rectangle

    # left side
    lw $a0,0($sp)
    li $a1,BORDER
    lw $a2,8($sp)
    lw $a3,12($sp)
    jal rectangle

    # right side
    lw $a0,0($sp)
    lw $t5,4($sp)
    add $a0,$a0,$t5 # x1 + width
    addi $a0,$a0,-BORDER # move over left by the border thickness
    li $a1,BORDER
    lw $a2,8($sp)
    lw $a3,12($sp)
    jal rectangle

    lw $ra,16($sp) # restore return address
    addi $sp,$sp,20
    jr $ra

# rectangle (resused from rectangle_template.asm in canvas)
rectangle:
# $t0 is the color 
beq $a1,$zero,rectangleReturn # edge case for 0s
beq $a3,$zero,rectangleReturn # edge case for 0s
#li $t0,0x00FFFFFF # color white 
#li $t0,0xFF0000FF # color blue
la $t1,imageBuffer
add $a1,$a1,$a0 # x2=width+x1
add $a3,$a3,$a2 # y2=height+y1
sll $a0,$a0,2 # scale x1 value to bytes (4 bytes per pixel)
sll $a1,$a1,2 # scale x2 value to bytes (4 bytes per pixel)
sll $a2,$a2,11 # scale y1 value to bytes (512*4 bytes per display row)
sll $a3,$a3,11 # scale y2 value to bytes (512*4 bytes per display row)
addu $t2,$a2,$t1 # row starting address(base + y1_scaled)
addu $a2,$t2,$a0 # first row pixel starting address(base + y1_scaled +X1_scaled)
addu $a3,$a3,$t1 # ending row address (base + y2_scaled)
addu $a3,$a3,$a0 # last row ending pixell addresss(base + y2_scaled +x2_scaled)
addu $t2,$t2,$a1 # and compute the ending address for first rectangle row (base + y1_scaled + x2_scaled)
li $t4,0x800 # offset per display row in bytes. 0x800 = 2048 = 512*4
rectangleYloop:
move $t3,$a2 # pointer to current pixel to start X loops; start at top-left corner
rectangleXloop:
sw $t0,($t3) # paint this pixel
addiu $t3,$t3,4 # increment byte address
bne $t3,$t2,rectangleXloop # keep going if not past the right edge of the rectangle
# continue Y loop for each row
addu $a2,$a2,$t4 # advace one row (left-edge pointer)
addu $t2,$t2,$t4 # advace one row (right-edge pointer)
bne $a2,$a3,rectangleYloop # keep going if not exceeding the bottom of the rectangle
# return from the rectangle procedure
rectangleReturn:
jr $ra
