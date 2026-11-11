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

.include "graphics_data.asm"

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

    # control labels under the gameboard
    jal draw_controls

    # Exit after returning
    li $v0,10
    syscall

# procedures
.include "draw_shapes.asm"
.include "draw_text.asm"
.include "draw_controls.asm"
.include "draw_number.asm"
.include "draw_tile.asm"
.include "print_matrix.asm"
.include "draw_scoreboard.asm"
.include "draw_screens.asm"
