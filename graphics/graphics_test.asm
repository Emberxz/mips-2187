# =====================================================================
# graphics_test.asm  -  test driver for the graphics (Person 5)
#
# Run this file (not graphics.asm) in MARS:
#   1. Settings -> check "Assemble all files in directory"
#   2. Settings -> check "Initialize Program Counter to global 'main' if defined"
#   3. Tools -> Bitmap Display, set the values listed in graphics.asm,
#      click "Connect to MIPS"
#   4. Open this file, Assemble, Run
#
# The labels below stand in for the real game globals (matrix, score,
# theme, high_scores). In the final game they come from the shared
# game data, so the graphics code must only READ them, never change them.
# Edit these values to test different boards.
# =====================================================================

        .globl  main
        .globl  matrix, score, theme, high_scores

        .data
# 16 cells, row-major: cell at row r, col c is word (r * 4 + c)
# Values are exponents: 0 = empty, 1 = 3, 2 = 9, ... 7 = 2187
matrix:         .word   0, 1, 2, 3
                .word   4, 5, 6, 7
                .word   0, 0, 1, 1
                .word   2, 0, 0, 3
score:          .word   2187
theme:          .word   0
high_scores:    .word   9000, 5000, 2187, 300, 0

        .text
main:
        jal     clear_screen
        jal     print_matrix            # draws the board from matrix + score

        # Uncomment one at a time to test the other screens:
        # jal   draw_title_screen
        # jal   draw_scoreboard
        # jal   you_win
        # jal   you_lose

        li      $v0, 10                 # exit
        syscall
