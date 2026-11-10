# 2187 graphics August Basinger
# WIP draws the outer box (blue) and the inner gameboard box (orange)

# Constants used so far
#   unit width in pixels: 1
#   unit height in pixels: 1
#   display width in pixels: 512
#   display height in pixels: 256
#   base address for display: 0x10010000 I think this is the default will have to confirm

.eqv BORDER 3    # thickness of each box outside

.data
imageBuffer:
.space 0x80000 # allocate space so 512 x 256 x 4

# for each font it is a 3x5 glyphs one word each has 15 bits
# address = font + index*4
# digit shapes I looked at the snake game shown from a previous project he showed
font:
#     hex       idx  char  offset
.word 0x7B6F  #  0   '0'   +0
.word 0x2C97  #  1   '1'   +4
.word 0x73E7  #  2   '2'   +8
.word 0x73CF  #  3   '3'   +12
.word 0x5BC9  #  4   '4'   +16
.word 0x79CF  #  5   '5'   +20
.word 0x79EF  #  6   '6'   +24
.word 0x7249  #  7   '7'   +28
.word 0x7BEF  #  8   '8'   +32
.word 0x7BCF  #  9   '9'   +36
.word 0x2BED  # 10   'A'   +40
.word 0x0000  # 11   'B'   +44   
.word 0x7927  # 12   'C'   +48
.word 0x6B6E  # 13   'D'   +52
.word 0x79A7  # 14   'E'   +56
.word 0x79A4  # 15   'F'   +60
.word 0x796F  # 16   'G'   +64
.word 0x5BED  # 17   'H'   +68
.word 0x7497  # 18   'I'   +72
.word 0x0000  # 19   'J'   +76   
.word 0x0000  # 20   'K'   +80
.word 0x4927  # 21   'L'   +84
.word 0x5FED  # 22   'M'   +88
.word 0x6B6D  # 23   'N'   +92
.word 0x7B6F  # 24   'O'   +96
.word 0x6BA4  # 25   'P'   +100
.word 0x2B73  # 26   'Q'   +104
.word 0x6BAD  # 27   'R'   +108
.word 0x79CF  # 28   'S'   +112
.word 0x7492  # 29   'T'   +116
.word 0x5B6F  # 30   'U'   +120
.word 0x0000  # 31   'V'   +124
.word 0x5B7D  # 32   'W'   +128
.word 0x5AAD  # 33   'X'   +132
.word 0x5A92  # 34   'Y'   +136
.word 0x72A7  # 35   'Z'   +140

# control labels 
# .asciiz lets me go through a string and convert each char
# to the asciiz value associated so W becomes 32 and I can use the
# letter from that to get the glyph from above
str_up:     .asciiz "W UP"
str_left:   .asciiz "A LEFT"
str_down:   .asciiz "S DOWN"
str_right:  .asciiz "D RIGHT"
str_rst:    .asciiz "R RESTART"
str_quit:   .asciiz "Q QUIT"
str_theme:  .asciiz "T THEME"
str_start:  .asciiz "Z START"
str_scores: .asciiz "X SCORES"

.text
main:
    # Blue box x1=128 width=256 y1=4 height=248
    li $t0,0x001E88E5           # its blue rn
    li $a0,128
    li $a1,256
    li $a2,4
    li $a3,248
    jal draw_box

    # Orange box(the game space) x1=140 width=232 y1=12 height=152
    li $t0,0x00FFA000           # orange for now
    li $a0,140
    li $a1,232
    li $a2,12
    li $a3,152
    jal draw_box

    # Exit after returning
    li $v0,10
    syscall

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
