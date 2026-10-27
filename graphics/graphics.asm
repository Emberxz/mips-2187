# =====================================================================
# graphics.asm  -  all drawing for 2187 (Person 5)
#
# Bitmap Display settings (Tools -> Bitmap Display) - change here AND in
# MARS together if you pick different ones:
#   Unit Width in Pixels:   4
#   Unit Height in Pixels:  4
#   Display Width:          512
#   Display Height:         512
#   Base address:           0x10040000 (heap)
#   -> 128 x 128 units, one 32-bit word (0x00RRGGBB) per unit
#   -> unit (x, y) lives at DISPLAY_BASE + (y * DISPLAY_W + x) * 4
#
# Calling conventions (until the group writes the official ones):
#   arguments in $a0-$a3, return value in $v0
#   save $ra and any $s registers you use; $t registers are scratch
#
# Globals this file READS (defined by the game / graphics_test.asm):
#   matrix (16 words), score, theme, high_scores (5 words)
# =====================================================================

        .eqv    DISPLAY_BASE    0x10040000
        .eqv    DISPLAY_W       128             # in units
        .eqv    DISPLAY_H       128             # in units

        # Color table indexes (see get_color)
        .eqv    COLOR_EMPTY     0               # 1-7 are the tile colors
        .eqv    COLOR_BG        8
        .eqv    COLOR_BORDER    9
        .eqv    COLOR_TEXT      10
        .eqv    COLORS_PER_THEME 11

        .globl  clear_screen, print_matrix, you_win, you_lose
        .globl  draw_title_screen, draw_scoreboard
        .globl  draw_rect, draw_tile, draw_number, draw_digit, get_color

        .data
# The color drawing routines use (set it before calling draw_rect).
pen_color:      .word   0

# Themes: COLORS_PER_THEME words each, in index order:
#   empty, tile 3, 9, 27, 81, 243, 729, 2187, background, border, text
# TODO: pick your colors (0x00RRGGBB). Add more themes by adding rows.
theme_colors:
theme0:         .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
theme1:         .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

# Digit font, one word per digit 0-9.
# TODO: choose a size (for example 3 wide x 5 tall = 15 bits) and pack
# each digit's pixels as bits, then document the bit order here.
digit_font:     .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0

        .text

# ---------------------------------------------------------------------
# clear_screen - fill the whole display with the background color
# args: none                 returns: nothing
# ---------------------------------------------------------------------
clear_screen:
        # TODO
        jr      $ra

# ---------------------------------------------------------------------
# print_matrix - draw the frame, all 16 tiles, and the score.
# Same name as the Python version so the game loop doesn't change.
# args: none (reads matrix, score)   returns: nothing
# ---------------------------------------------------------------------
print_matrix:
        # TODO
        jr      $ra

# ---------------------------------------------------------------------
# you_win / you_lose - end screen with "press R to restart"
# args: none                 returns: nothing
# ---------------------------------------------------------------------
you_win:
        # TODO
        jr      $ra

you_lose:
        # TODO
        jr      $ra

# ---------------------------------------------------------------------
# draw_title_screen - "2187" plus the menu keys (Z start, T theme, X scores)
# args: none                 returns: nothing
# ---------------------------------------------------------------------
draw_title_screen:
        # TODO
        jr      $ra

# ---------------------------------------------------------------------
# draw_scoreboard - list the 5 high scores
# args: none (reads high_scores)     returns: nothing
# ---------------------------------------------------------------------
draw_scoreboard:
        # TODO
        jr      $ra

# ---------------------------------------------------------------------
# draw_rect - filled rectangle in pen_color
# args: $a0 = x, $a1 = y, $a2 = width, $a3 = height (all in units)
# returns: nothing
# ---------------------------------------------------------------------
draw_rect:
        # TODO
        jr      $ra

# ---------------------------------------------------------------------
# draw_tile - one board square in its exponent's color, with its value
# args: $a0 = row (0-3), $a1 = col (0-3), $a2 = exponent (0-7)
# returns: nothing
# ---------------------------------------------------------------------
draw_tile:
        # TODO
        jr      $ra

# ---------------------------------------------------------------------
# draw_number - draw a 1-4 digit number (2187 is the widest)
# args: $a0 = x, $a1 = y, $a2 = value
# returns: nothing
# ---------------------------------------------------------------------
draw_number:
        # TODO
        jr      $ra

# ---------------------------------------------------------------------
# draw_digit - draw one digit from digit_font
# args: $a0 = x, $a1 = y, $a2 = digit (0-9)
# returns: nothing
# ---------------------------------------------------------------------
draw_digit:
        # TODO
        jr      $ra

# ---------------------------------------------------------------------
# get_color - look up a color in the current theme
# args: $a0 = color index (0-7 tile, COLOR_BG, COLOR_BORDER, COLOR_TEXT)
# returns: $v0 = color (0x00RRGGBB)
# ---------------------------------------------------------------------
get_color:
        # TODO
        li      $v0, 0
        jr      $ra
