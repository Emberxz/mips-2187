# graphics test data
# Its just values I made up so the graphics cxan run by itself
# just keeping it incase

# real value of each exponent
pow3:       .word 0, 3, 9, 27, 81, 243, 729, 2187
            .word 6561, 19683, 59049, 177147

# test board, row by row: cell (row, col) is word row*4 + col
matrix:     .word 11, 10, 9, 8
            .word 4, 5, 6, 7
            .word 3, 2, 1, 0
            .word 0, 1, 0, 2

# test score for the live score and the win/lose pop-up
score:      .word 48213

# test high scores (the real game starts these at all 0)
high_scores: .word 48213, 1458, 0, 0, 0

# test theme 0 = home 1 = away
theme:      .byte 0
