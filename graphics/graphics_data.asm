# graphics data: font table and label strings
# included inside .data in graphics.asm, after imageBuffer

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

# tile tables one word per exponent 0-11 (0 = empty, 11 = 177147 the winning tile)
# real value of each exponent
pow3:       .word 0, 3, 9, 27, 81, 243, 729, 2187
            .word 6561, 19683, 59049, 177147
# tile colors
#                 empty       3           9           27
tileColors: .word 0x0054657A, 0x0048AAD0, 0x00DBA43D, 0x00F0873B
#                 81          243         729         2187
            .word 0x00F26B5B, 0x00E04F8F, 0x008F5FD6, 0x003CB371
#                 6561        19683       59049       177147
            .word 0x002A9D8F, 0x003A6EA5, 0x00B03A7A, 0x00D49A00
# how far right of the tile's left edge the number starts so it is centered
# (51 - width) / 2
#   exponents 1-8  use scale 3: width = digits*12 - 3
#   exponents 9-11 use scale 2: width = digits*8 - 2 (5 and 6 digits are too wide at scale 3)
#                 -   3   9  27  81 243 729 2187 6561 19683 59049 177147
tileTextX:  .word 0, 21, 21, 15, 15,  9,  9,  3,   3,    6,    6,     2

# theme colors (I got the colors from https://ocm.auburn.edu/brand-center/_assets/pdf/au-colorpalette-primary-supporting.pdf)
# each theme is just 2 colors
#   +0 background
#   +4 outerbox/ game box
#                 background  outerbox/ game box
themeHome:  .word 0x000B2341, 0x00FFFFFF             # blue with white
themeAway:  .word 0x00FFFFFF, 0x000B2341             # white with blue

# TEMP test board so print_matrix has something to draw
# remove this once the game data file defines the real matrix
matrix:     .word 11, 10, 9, 8
            .word 4, 5, 6, 7
            .word 3, 2, 1, 0
            .word 0, 1, 0, 2
# TEMP test score so the win/lose pop-up has a number to show
score:      .word 48213
# TEMP test high scores (the team file starts these at all 0)
high_scores: .word 48213, 1458, 0, 0, 0
# TEMP test theme 0 = home 1 = away (the team file has the real one)
theme:      .byte 0

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

# win / lose pop-up
str_win:    .asciiz "YOU WIN"
str_lose:   .asciiz "YOU LOSE"
str_score:  .asciiz "SCORE"

# high scores pop-up
str_hiscores: .asciiz "HIGH SCORES"
str_close:  .asciiz "X CLOSE"

# used by draw_number to hold the digits
numBuf:     .space 8
