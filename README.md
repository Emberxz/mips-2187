# mips-2187

2048 in base 3, written in MIPS assembly for MARS. Two equal tiles merge into one tile worth 3× as much (3 + 3 → 9, 9 + 9 → 27, …), and reaching 2187 (3^7) wins.

## Layout

| Folder | Owner | What's in it |
| --- | --- | --- |
| `graphics/` | August Basinger | All drawing for the MARS Bitmap Display |
| `movement/` | Person 1 | Turning each direction into lines: `move`, `get_line`, `set_line` |
| `merge/` | Person 2 | Sliding and merging a line: `slide_merge_line`, `compress_line`, `merge_line` |
| `board/` | Person 3 | Setting up the board and checking win/loss: `init_matrix`, `spawn_tile`, `check_mat`, `can_move` |
| `game_loop/` | Person 4 | Main loop, input, score, start screen, and printing the board |

## Shared data

Tiles are stored as exponents, not values: 0 = empty, 1 = 3, 2 = 9, … 7 = 2187. The board is 16 words, row by row, so the cell at row r, column c is word `r * 4 + c`. The graphics only read `matrix`, `score`, `theme` and `high_scores`; they never change them.
