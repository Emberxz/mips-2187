# 2187 graphics August Basinger
# WIP draws the outer box (blue) and the inner gameboard box (orange)

# Constants used so far
#   unit width in pixels: 1
#   unit height in pixels: 1
#   display width in pixels: 512
#   display height in pixels: 256
#   base address for display: 0x10010000 I think this is the default will have to confirm

.data
imageBuffer:
.space 0x80000 # allocate space so 512 x 256 x 4

.include "graphics_data.asm"
.include "graphics_test_data.asm"   # just my testing data not really needed anymore

.text
main:
    # sets up background boxes controls and all 16 tiles in the current theme
    jal draw_game_screen

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
